output "admin" {
  value = {
    username        = var.admin_user
    ssh_private_key = var.ssh_private_key
    ssh_public_key  = var.ssh_public_key
  }
}

output "clientvm_node" {
  value = {
    hostname   = var.clientvm_hostname
    public_ip  = azurerm_public_ip.clientvm.ip_address
    private_ip = azurerm_network_interface.clientvm.private_ip_address
  }
}
