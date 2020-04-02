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
