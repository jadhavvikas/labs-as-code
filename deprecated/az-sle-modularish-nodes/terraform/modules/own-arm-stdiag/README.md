## Creates a storage account for boot diagnostistics

### Provides

* storage account for diagnostics

### Usage

```{text}
module "stdiag" {
  source              = "./modules/own-arm-stdiag"
  resource_group_name = azurerm_resource_group.rg.name
}
```

### Notes

* Inherits `location` and `tags` from passed `resource_group_name`.
* [How to use boot diagnostics to troubleshoot virtual machines in Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/troubleshooting/boot-diagnostics)
