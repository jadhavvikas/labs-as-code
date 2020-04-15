## Project and common infrastructure

variable "tags" {
  description = "azure tags for cluster resources"
  type        = map(string)

  default = {
    owner  = "Brendon Caligari"
    status = "in use"
    #status = "safe to delete"
  }
}

variable "resource_group_name" {
  description = "resource group for this cluster"
  type        = string
  default     = "rg-bc-instance"
}

variable "location" {
  description = "location"
  type        = string
  default     = "East US"
}

variable "default_vnet_suffix" {
  description = "default vnet for this cluster"
  type        = string
  default     = "default"
}

variable "default_vnet_address_space" {
  description = "address space for vnet"
  type        = string
  default     = "172.16.0.0/16"
}

variable "default_snet_suffix" {
  description = "default subnet for this cluster"
  type        = string
  default     = "default"
}

variable "default_snet_address_prefix" {
  description = "address prefix for snet"
  type        = string
  default     = "172.16.0.0/24"
}

variable "cluster_service_name" {
  description = "name of the cluster service we are exposing"
  type        = string
  default     = "nfs"
}

## Admin user and SSH details

variable "admin_user" {
  description = "privileged (sudo) user for ssh login"
  type        = string
  default     = "sysop"
}

variable "ssh_private_key" {
  description = "ssh private key"
  type        = string
  default     = "~/.credentials/id_rsa"
}

variable "ssh_public_key" {
  description = "ssh public key"
  type        = string
  default     = "~/.credentials/id_rsa.pub"
}

## clientvm virtual machine

variable "clientvm_hostname" {
  description = "hostname for clientvm vm"
  type        = string
  default     = "clientvm"
}

variable "clientvm_vm_size" {
  description = "vm_size for clientvm vm"
  type        = string
  #default     = "Standard_B2s"
  default = "Standard_B1s"
}

variable "clientvm_image" {
  description = "storage image reference for clientvm vm"
  type        = map(string)

  default = {
    publisher = "SUSE"
    offer     = "SLES-SAP-BYOS"
    sku       = "12-SP3"
    version   = "2019.11.18"
  }
}
