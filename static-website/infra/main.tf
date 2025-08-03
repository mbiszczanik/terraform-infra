# Resource Group for Static Website
resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment    = "D"
    Infrastructure = "Core"
    Location       = "West Europe"
  }
}

# Storage account for static website hosting
resource "azurerm_storage_account" "storageAccount" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  static_website {
    index_document = "index.html"
  }

  tags = {
    Environment    = "D"
    Infrastructure = "Core"
    Location       = "West Europe"
  }
}

# Upload index.html as a blob to the $web container
resource "azurerm_storage_blob" "storageBlob" {
  name                   = var.index_document
  storage_account_name   = var.storage_account_name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source_content         = var.source_content
}