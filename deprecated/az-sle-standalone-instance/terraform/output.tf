output "resource_group" {
  value = "rg-${random_id.this_instance.hex}"
}

output "public_ip" {
  value = azurerm_public_ip.disposable_pip.ip_address
}

output "user" {
  value = var.login_creds.user
}

output "hostname" {
  value = "srv${random_id.this_instance.hex}"
}

output "ssh_private_key" {
  value = var.login_creds.private_key
}

output "ssh" {
  value = "ssh -i ${var.login_creds.private_key} ${var.login_creds.user}@${azurerm_public_ip.disposable_pip.ip_address}"
}
