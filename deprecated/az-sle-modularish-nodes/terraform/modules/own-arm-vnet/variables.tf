variable "resource_group_name" {
  description = "Pre-existing Azure resource group"
  type        = string
}

variable "name" {
  description = "vnet name"
  type        = string
  default     = "vnet-default"
}

variable "address_space" {
  description = "IPv4 CIDR space"
  type        = list(string)
  default     = ["172.16.0.0/16"]
}

variable "subnet_ids" {
  description = "Names for subnets within vnet"
  type        = list(string)
  default     = ["snet-0"]
}

variable "subnet_cidrs" {
  description = "CIDR for subnets within vnet"
  type        = list(string)
  default     = ["172.16.0.0/24"]
}

