data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "azurerm_public_ip" "pip" {
  count               = length(var.nodenames)
  name                = "pip-${var.nodenames[count.index]}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  allocation_method   = "Static"
  tags                = data.azurerm_resource_group.rg.tags
}

resource "azurerm_network_interface" "nic" {
  count                     = length(var.nodenames)
  name                      = "nic-${var.nodenames[count.index]}"
  resource_group_name       = data.azurerm_resource_group.rg.name
  location                  = data.azurerm_resource_group.rg.location
  network_security_group_id = var.network_security_group_id

  ip_configuration {
    name                          = "eth0"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[count.index].id
  }

  tags = data.azurerm_resource_group.rg.tags
}

resource "azurerm_virtual_machine" "vm" {
  count                 = length(var.nodenames)
  name                  = "vm-${var.nodenames[count.index]}"
  resource_group_name   = data.azurerm_resource_group.rg.name
  location              = data.azurerm_resource_group.rg.location
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  vm_size               = var.vm_size

  storage_os_disk {
    name              = "osdisk-${var.nodenames[count.index]}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = var.storage_image_reference.publisher
    offer     = var.storage_image_reference.offer
    sku       = var.storage_image_reference.sku
    version   = var.storage_image_reference.version
  }

  os_profile {
    computer_name  = var.nodenames[count.index]
    admin_username = var.username
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.username}/.ssh/authorized_keys"
      key_data = file(var.ssh_key)
    }
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = var.stdiag_primary_blob_endpoint
  }

  tags = data.azurerm_resource_group.rg.tags
}
