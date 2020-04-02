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

output "cluster_nodes" {
  value = {
    hostnames  = var.cluster_hostnames
    private_ip = azurerm_network_interface.clustervms.*.private_ip_address
  }
}

output "azure_load_balancer" {
  value = {
    lb_id       = azurerm_lb.nfs_lb.id
    frontends   = azurerm_lb.nfs_lb.frontend_ip_configuration[*].name
    private_ips = azurerm_lb.nfs_lb.frontend_ip_configuration[*].private_ip_address
  }
}
