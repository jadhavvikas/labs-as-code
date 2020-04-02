## Azure

* [Azure Terraform Provider](https://www.terraform.io/docs/providers/azurerm/index.html)
* [Recommended naming and tagging conventions](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging)
* `az` client is in `azure-cli` from the main openSUSE repository
    * `az login` - login will output same as `az account list` json
    * `az account set --subscription="..."`
    * Create service principal:
        * `az ad sp create-for-rbac --name whatever`
    * Export variables from service principal

## Query stuff

* `az vm image list --all --publisher SUSE --offer SLES --output table`


### Exporting service principal to Terraform

```{text}
export ARM_SUBSCRIPTION_ID='<azure-subscription-id>'`
export ARM_CLIENT_ID='<service-principal-app-id>'                     # aka app id
export ARM_CLIENT_SECRET='<service-principal-password>'               # aka password
export ARM_TENANT_ID='<service-principal-tenant-id>'
```

### Exporting service principal to Ansible

* [Ansible Azure Scenario](https://docs.ansible.com/ansible/latest/scenario_guides/guide_azure.html)

```{text}
export AZURE_SUBSCRIPTION_ID='<azure-subscription-id>'
export AZURE_CLIENT_ID='<service-principal-app-id>'
export AZURE_SECRET='<service-principal-password>'
export AZURE_TENANT='<service-principal-tenant-id>'
```
