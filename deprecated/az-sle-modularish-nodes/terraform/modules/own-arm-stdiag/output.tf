output "azurerm_storage_account" {
  description = "Storage account for diagnostics"
  value       = azurerm_storage_account.stdiag.name
}

output "azurerm_storage_account_primary_blob_endpoint" {
  description = "Storage account for diagnostics"
  value       = azurerm_storage_account.stdiag.primary_blob_endpoint
}
