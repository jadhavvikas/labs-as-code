terraform {
  required_version = "~> 0.12"
}

provider "azurerm" {
  version = "~> 1.36.1"
}

provider "random" {
  version = "~> 2.2"
}

resource "random_id" "this_instance" {
  byte_length = 4
}

resource "azurerm_resource_group" "disposable_rg" {
  name     = "rg-${random_id.this_instance.hex}"
  location = var.az_location
  tags     = var.az_tags
}

resource "azurerm_virtual_network" "disposable_vnet" {
  name                = "vnet-${random_id.this_instance.hex}"
  location            = var.az_location
  address_space       = ["172.16.0.0/16"]
  resource_group_name = azurerm_resource_group.disposable_rg.name
  tags                = var.az_tags
}

resource "azurerm_subnet" "disposable_snet" {
  name                 = "snet-${random_id.this_instance.hex}"
  resource_group_name  = azurerm_resource_group.disposable_rg.name
  virtual_network_name = azurerm_virtual_network.disposable_vnet.name
  address_prefix       = "172.16.0.0/24"
}

resource "azurerm_public_ip" "disposable_pip" {
  name                = "pip-${random_id.this_instance.hex}"
  location            = var.az_location
  resource_group_name = azurerm_resource_group.disposable_rg.name
  allocation_method   = "Static"
  tags                = var.az_tags
}

resource "azurerm_network_security_group" "disposable_nsg" {
  name                = "nsg-${random_id.this_instance.hex}"
  location            = var.az_location
  resource_group_name = azurerm_resource_group.disposable_rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.az_tags
}

resource "azurerm_network_interface" "disposable_nic" {
  name                      = "nic-${random_id.this_instance.hex}"
  location                  = var.az_location
  resource_group_name       = azurerm_resource_group.disposable_rg.name
  network_security_group_id = azurerm_network_security_group.disposable_nsg.id

  ip_configuration {
    name                          = "nic-${random_id.this_instance.hex}"
    subnet_id                     = azurerm_subnet.disposable_snet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.disposable_pip.id
  }

  tags = var.az_tags
}

resource "azurerm_storage_account" "disposable_stdiag" {
  name                     = "stdiag${random_id.this_instance.hex}"
  location                 = var.az_location
  resource_group_name      = azurerm_resource_group.disposable_rg.name
  account_replication_type = "LRS"
  account_tier             = "Standard"
  tags                     = var.az_tags
}

resource "azurerm_virtual_machine" "disposable_vm" {
  name                  = "vm-${random_id.this_instance.hex}"
  location              = var.az_location
  resource_group_name   = azurerm_resource_group.disposable_rg.name
  network_interface_ids = [azurerm_network_interface.disposable_nic.id]
  vm_size               = var.az_vm_size

  storage_os_disk {
    name              = "disk-${random_id.this_instance.hex}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = var.az_image.publisher
    offer     = var.az_image.offer
    sku       = var.az_image.sku
    version   = var.az_image.version
  }

  os_profile {
    computer_name  = "srv${random_id.this_instance.hex}"
    admin_username = var.login_creds.user
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/sysop/.ssh/authorized_keys"
      key_data = file(var.login_creds.public_key)
    }
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = azurerm_storage_account.disposable_stdiag.primary_blob_endpoint
  }

  tags = var.az_tags
}
