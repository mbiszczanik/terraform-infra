# Moving terraform.tfstate file to secure remote location

# az group create --name test-tf-rg --location westeurope
# az storage account create --name testtfst12 --location westeurope --resource-group test-tf-rg
# $ACCOUNT_KEY=az storage account keys list --resource-group test-tf-rg --account-name testtfst12 --query '[0].value' -o tsv
# az storage container create --account-name testtfst12  --name testtfcontainer --public-access off --account-key $ACCOUNT_KEY

# Add storage accounts from code

terraform {
    backend "azurerm" {
        resource_group_name = "test-tf-rg"
        storage_account_name = "testtfst12"
        container_name = "testtfcontainer"
        key = "terraform.tfstate"
    }
}