provider "azurerm" {
  version = "~> 2.0.0"
  features {}
}

# All resources will go into this resource group
resource "azurerm_resource_group" "common" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# A virtual network will host all subnets
resource "azurerm_virtual_network" "common" {
  name                = "vnet-${var.default_vnet_suffix}"
  resource_group_name = azurerm_resource_group.common.name
  location            = azurerm_resource_group.common.location
  address_space       = [var.default_vnet_address_space]
  tags                = azurerm_resource_group.common.tags
}

# Only one subnet needed in this case
resource "azurerm_subnet" "common" {
  name                 = "snet-${var.default_snet_suffix}"
  resource_group_name  = azurerm_resource_group.common.name
  virtual_network_name = azurerm_virtual_network.common.name
  address_prefix       = var.default_snet_address_prefix
}

# Basic nsg for linux hosts
resource "azurerm_network_security_group" "basic_nsg" {
  name                = "nsg-${var.cluster_service_name}"
  resource_group_name = azurerm_resource_group.common.name
  location            = azurerm_resource_group.common.location

  security_rule {
    name                       = "nsg-basic"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = azurerm_resource_group.common.tags
}

# clientvm instance will need a public IP as it will double as jump host
resource "azurerm_public_ip" "clientvm" {
  name                = "pip-${var.clientvm_hostname}"
  resource_group_name = azurerm_resource_group.common.name
  location            = azurerm_resource_group.common.location
  allocation_method   = "Static"
  tags                = azurerm_resource_group.common.tags
}

# Only a single NIC is required for the clientvm vm
resource "azurerm_network_interface" "clientvm" {
  name                = "nic-${var.clientvm_hostname}"
  resource_group_name = azurerm_resource_group.common.name
  location            = azurerm_resource_group.common.location
  tags                = azurerm_resource_group.common.tags

  ip_configuration {
    name                          = "eth0"
    subnet_id                     = azurerm_subnet.common.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.clientvm.id
  }
}

# The actual clientvm vm resource
resource "azurerm_linux_virtual_machine" "clientvm" {
  name                            = "vm-${var.clientvm_hostname}"
  resource_group_name             = azurerm_resource_group.common.name
  location                        = azurerm_resource_group.common.location
  network_interface_ids           = [azurerm_network_interface.clientvm.id]
  size                            = var.clientvm_vm_size
  computer_name                   = var.clientvm_hostname
  admin_username                  = var.admin_user
  disable_password_authentication = true

  source_image_reference {
    publisher = var.clientvm_image["publisher"]
    offer     = var.clientvm_image["offer"]
    sku       = var.clientvm_image["sku"]
    version   = var.clientvm_image["version"]
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_ssh_key {
    username   = var.admin_user
    public_key = file(var.ssh_public_key)
  }

  tags = azurerm_resource_group.common.tags
}
