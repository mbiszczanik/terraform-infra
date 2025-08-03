# Resource Group for AKS Lab
resource "azurerm_resource_group" "rg" {
  name     = "AKSLab-NEu-RG01"
  location = "North Europe"
  tags = {
    Environment    = "D"
    Infrastructure = "Common"
    Location       = "North Europe"
  }
}

# Random DNS prefix for AKS
resource "random_pet" "azurerm_kubernetes_cluster_dns_prefix" {
  prefix = "dns"
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "AKSLab-NEu-AKS01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = random_pet.azurerm_kubernetes_cluster_dns_prefix.id

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_B2s"
    node_count = var.node_count
  }

  linux_profile {
    admin_username = "ubuntu"
    ssh_key {
      key_data = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
    }
  }

  network_profile {
    network_plugin      = "kubenet"
    load_balancer_sku   = "standard"
  }
}