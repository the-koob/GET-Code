terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.62.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

data "azurerm_resource_group" "getng_rg" {
  name = "ct-p-zeaus-getng-rg"
}
data "azurerm_kubernetes_cluster" "getng_aks" {
  name = "ct-p-zeaus-getng-aks"
  resource_group_name = data.azurerm_resource_group.getng_rg.name
}
