# Cluster node public IP to be removed later
resource "azurerm_public_ip" "clustervms" {
  count               = length(var.cluster_hostnames)
  name                = "pip-${var.cluster_hostnames[count.index]}"
  resource_group_name = azurerm_resource_group.common.name
  location            = azurerm_resource_group.common.location
  allocation_method   = "Static"
  tags                = azurerm_resource_group.common.tags
}

# If we don't put all VMs in the same availability set we are buggered
resource "azurerm_availability_set" "clustervms" {
  name                = "aset-${var.cluster_service_name}"
  resource_group_name = azurerm_resource_group.common.name
  location            = azurerm_resource_group.common.location
  managed             = true
  tags                = azurerm_resource_group.common.tags
}

# Only a single NIC per cluster node is used for now
resource "azurerm_network_interface" "clustervms" {
  count               = length(var.cluster_hostnames)
  name                = "nic-${var.cluster_hostnames[count.index]}"
  resource_group_name = azurerm_resource_group.common.name
  location            = azurerm_resource_group.common.location
  tags                = azurerm_resource_group.common.tags

  ip_configuration {
    name                          = "eth0"
    subnet_id                     = azurerm_subnet.common.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.clustervms[count.index].id
  }
}

# The actual vm resource for each cluster node
resource "azurerm_linux_virtual_machine" "clustervms" {
  count                           = length(var.cluster_hostnames)
  name                            = "vm-${var.cluster_hostnames[count.index]}"
  resource_group_name             = azurerm_resource_group.common.name
  location                        = azurerm_resource_group.common.location
  network_interface_ids           = [azurerm_network_interface.clustervms[count.index].id]
  size                            = var.cluster_vm_size
  availability_set_id             = azurerm_availability_set.clustervms.id
  computer_name                   = var.cluster_hostnames[count.index]
  admin_username                  = var.admin_user
  disable_password_authentication = true

  source_image_reference {
    publisher = var.cluster_image["publisher"]
    offer     = var.cluster_image["offer"]
    sku       = var.cluster_image["sku"]
    version   = var.cluster_image["version"]
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

# A data storage data disk is created for each cluster node
resource "azurerm_managed_disk" "clustervms_data0" {
  count                = length(var.cluster_hostnames)
  name                 = "${azurerm_linux_virtual_machine.clustervms[count.index].name}-DataDisk0"
  resource_group_name  = azurerm_resource_group.common.name
  location             = azurerm_resource_group.common.location
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.disk_size_gb_data0
}

# The storage data disk has to be attached to the respective vm
resource "azurerm_virtual_machine_data_disk_attachment" "clustervms_data0" {
  count              = length(var.cluster_hostnames)
  managed_disk_id    = azurerm_managed_disk.clustervms_data0[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.clustervms[count.index].id
  lun                = "10"
  caching            = "ReadWrite"
}
