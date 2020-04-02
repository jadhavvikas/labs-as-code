variable "resource_group_name" {
  description = "Azure resource group"
  type        = string
}

variable "nodenames" {
  description = "node names"
  type        = list(string)
}

variable "subnet_id" {
  description = "subnet id"
  type        = string
}

variable "network_security_group_id" {
  description = "network sexcurity group id"
  type        = string
}

variable "vm_size" {
  description = "virtual machine size"
  type        = string
}

variable "username" {
  description = "login user"
  type        = string
}

variable "ssh_key" {
  description = "file path for ssh private key"
  type        = string
}

variable "stdiag_primary_blob_endpoint" {
  description = "storage account primary blob endpoint for diagnostics"
  type        = string
}

variable "storage_image_reference" {
  description = "image for this project"
  type        = map(string)
}
