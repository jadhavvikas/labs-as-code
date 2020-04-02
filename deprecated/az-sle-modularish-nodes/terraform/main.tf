provider "azurerm" {
  version = "~> 1.36.1"
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Add a virtual network and subnet in same location
module "network" {
  source              = "./modules/own-arm-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.vnet.address_space]
  name                = var.vnet.name
  subnet_ids          = [var.vnet.subnet_id]
  subnet_cidrs        = [var.vnet.subnet_cidr]
}

# We need a storage account for diagnostics (apparently)
module "stdiag" {
  source              = "./modules/own-arm-stdiag"
  resource_group_name = azurerm_resource_group.rg.name
}

# A simple Netwok Security Group that just allows SSH should suffice
module "nsg-simple" {
  source              = "./modules/own-arm-simple-nsg"
  resource_group_name = azurerm_resource_group.rg.name
}

# Spin up the ""client"" nodes
module "vm-client" {
  source                       = "./modules/own-arm-sle-host"
  resource_group_name          = azurerm_resource_group.rg.name
  nodenames                    = var.client_node_names
  subnet_id                    = module.network.azurerm_subnet.0
  network_security_group_id    = module.nsg-simple.azurerm_network_security_group_id
  vm_size                      = var.client_node_az_size
  username                     = var.login_creds.user
  ssh_key                      = var.login_creds.public_key
  stdiag_primary_blob_endpoint = module.stdiag.azurerm_storage_account_primary_blob_endpoint
  storage_image_reference      = var.az_storage_image_reference
}

# Spin up the ""cluster"" nodes
module "vm-nodes" {
  source                       = "./modules/own-arm-sle-host"
  resource_group_name          = azurerm_resource_group.rg.name
  nodenames                    = var.cluster_node_names
  subnet_id                    = module.network.azurerm_subnet.0
  network_security_group_id    = module.nsg-simple.azurerm_network_security_group_id
  vm_size                      = var.cluster_node_az_size
  username                     = var.login_creds.user
  ssh_key                      = var.login_creds.public_key
  stdiag_primary_blob_endpoint = module.stdiag.azurerm_storage_account_primary_blob_endpoint
  storage_image_reference      = var.az_storage_image_reference
}
