output "vm-name" {
  description = "vm azure resource name"
  value       = azurerm_public_ip.pip[*].ip_address
}

output "vm-id" {
  description = "vm azure id"
  value       = azurerm_virtual_machine.vm[*].id
}

output "public_ip" {
  description = "instance public ip"
  value       = azurerm_public_ip.pip[*].ip_address
}

output "private_ip" {
  description = "instance private ip"
  value       = azurerm_network_interface.nic[*].private_ip_address
}
