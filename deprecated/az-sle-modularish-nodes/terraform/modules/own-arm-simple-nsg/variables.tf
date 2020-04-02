variable "resource_group_name" {
  description = "Azure resource group"
  type        = string
}

variable "name" {
  description = "nsg name"
  type        = string
  default     = "nsg-simple"
}
