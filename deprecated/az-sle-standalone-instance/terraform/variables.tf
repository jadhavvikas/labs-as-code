variable "az_location" {
  description = "Azure location code"
  default     = "eastus2"
}

variable "az_vm_size" {
  description = "Azure VM size"
  default     = "Standard_DS1_v2"
}

variable "az_tags" {
  description = "Tags for this project"
  type        = map

  default = {
    environment = "test"
    treatment   = "disposable"
  }
}

variable "az_image" {
  description = "Image for this project"
  type        = map

  default = {
    publisher = "SUSE"
    offer     = "SLES-SAP-BYOS"
    sku       = "12-SP3"
    version   = "2019.11.18"
  }
}

variable "login_creds" {
  description = "SSH keys"
  type        = map

  default = {
    user        = "sysop"
    private_key = "~/.credentials/id_rsa",
    public_key  = "~/.credentials/id_rsa.pub"
  }
}
