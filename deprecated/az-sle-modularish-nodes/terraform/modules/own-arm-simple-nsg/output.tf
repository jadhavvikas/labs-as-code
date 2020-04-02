output "azurerm_network_security_group" {
  description = "network security group"
  value       = azurerm_network_security_group.nsg.name
}

output "azurerm_network_security_group_id" {
  description = "network security group"
  value       = azurerm_network_security_group.nsg.id
}
