# Variables for main.tf

# variable "tags" {
#   description = "Tags"
# }

variable "location" {
  description = "The Azure region which contains all resources"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group which contains resources"
}

variable "storage_account_name" {
    description = "The name of the Storage Account to create"
}

variable "source_content" {
  description = "The content of the index.html file"
}

variable "index_document" {
  description = "The name of the index document"
}