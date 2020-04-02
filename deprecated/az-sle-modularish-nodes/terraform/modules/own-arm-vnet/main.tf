data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "azurerm_virtual_network" "vnet" {
  resource_group_name = var.resource_group_name
  name                = var.name
  location            = data.azurerm_resource_group.rg.location
  address_space       = var.address_space
  tags                = data.azurerm_resource_group.rg.tags
}

resource "azurerm_subnet" "snet" {
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  count                = length(var.subnet_ids)
  name                 = var.subnet_ids[count.index]
  address_prefix       = var.subnet_cidrs[count.index]
}
