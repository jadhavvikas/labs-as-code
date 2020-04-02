## Creates a virtual network and subnets

### Provides

* virtual network
* subnets

### Usage

```{text}
module "network" {
  source              = "./modules/own-arm-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.vnet.address_space]
  name                = var.vnet.name
  subnet_ids          = [var.vnet.subnet_id]
  subnet_cidrs        = [var.vnet.subnet_cidr]
}
```

### Notes

* Inherits `tags` and `location` from passed `resource_group_name`.
