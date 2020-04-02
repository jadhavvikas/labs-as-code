data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "random_id" "rnd" {
  keepers = {
    rg  = data.azurerm_resource_group.rg.name
    loc = data.azurerm_resource_group.rg.location
  }

  byte_length = 8
}

resource "azurerm_storage_account" "stdiag" {
  name                     = "stdiag${random_id.rnd.hex}"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = data.azurerm_resource_group.rg.tags
}
