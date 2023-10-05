# Resource Group
resource "azurerm_resource_group" "resourceGroup" {
  name     = "core-weu-rg01"
  location = "westeurope"

  tags = {
    Environment    = "D"
    Infrastructure = "Core"
    Location       = "West Europe"
  }
}

# Storage account
resource "azurerm_storage_account" "storageAccount" {
  name                     = "coreweust01"
  resource_group_name      = azurerm_resource_group.resourceGroup.name
  location                 = azurerm_resource_group.resourceGroup.location
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

# Container
resource "azurerm_storage_blob" "storageBlob" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.storageAccount.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source_content         = "<h1> Test website </h1>"
}