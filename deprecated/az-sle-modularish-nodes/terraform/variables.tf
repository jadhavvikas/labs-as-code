variable "location" {
  description = "Azure location code"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Azure resource group name"
  type        = string
  default     = "rg-duckpond"
}

variable "vnet" {
  description = "Virtual network specifics"
  type        = map

  default = {
    name          = "vnet-default"
    address_space = "172.16.0.0/16"
    subnet_id     = "snet-default"
    subnet_cidr   = "172.16.0.0/24"
  }
}

variable "tags" {
  description = "Tags for Azure resources"
  type        = map(string)

  default = {
    environment = "test"
    owner       = "bc"
  }
}

variable "cluster_node_names" {
  description = "Cluster node names"
  type        = list(string)
  default     = ["node0", "node1"]
}

variable "cluster_node_az_size" {
  description = "cluster node machine size"
  type        = string
  default     = "Standard_B2s"
}

variable "client_node_names" {
  description = "Client node names"
  type        = list(string)
  default     = ["client"]
}

variable "client_node_az_size" {
  description = "client node machine size"
  type        = string
  default     = "Standard_B2s"
}

variable "az_storage_image_reference" {
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
