output "azurerm_virtual_network" {
  description = "Virtual network"
  value       = azurerm_virtual_network.vnet.name
}

output "azurerm_subnet" {
  description = "Subnet IDs"
  value       = azurerm_subnet.snet.*.id
}
