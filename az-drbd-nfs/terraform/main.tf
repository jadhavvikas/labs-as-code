provider "azurerm" {
  version = "~> 2.0.0"
  features {}
}

# All resources will go into this resource group
resource "azurerm_resource_group" "common" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# A virtual network will host all subnets
resource "azurerm_virtual_network" "common" {
  name                = "vnet-${var.default_vnet_suffix}"
  resource_group_name = azurerm_resource_group.common.name
  location            = azurerm_resource_group.common.location
  address_space       = [var.default_vnet_address_space]
  tags                = azurerm_resource_group.common.tags
}

# Only one subnet needed in this case
resource "azurerm_subnet" "common" {
  name                 = "snet-${var.default_snet_suffix}"
  resource_group_name  = azurerm_resource_group.common.name
  virtual_network_name = azurerm_virtual_network.common.name
  address_prefix       = var.default_snet_address_prefix
}

# Basic nsg for linux hosts
resource "azurerm_network_security_group" "basic_nsg" {
  name                = "nsg-${var.cluster_service_name}"
  resource_group_name = azurerm_resource_group.common.name
  location            = azurerm_resource_group.common.location

  security_rule {
    name                       = "nsg-basic"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = azurerm_resource_group.common.tags
}
