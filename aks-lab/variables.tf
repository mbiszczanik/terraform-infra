variable "resource_group_location" {
  type = string
  default = "North Europe"
  description = "Location of Resource Group"
}

variable "resource_group_name_prefix" {
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "node_count" {
  type = number
  default = 3
  description = "Quantity of nodes for the node pool"
}

variable "msi_id" {
  type = string
  description = "The Managed Identity ID"
  default = null
}