terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.44.0"
    }
  }
}

provider "azurerm" {
    features {}
}

data "azurerm_resource_group" "getng_rg" {
  name = "ct-n-zeaus-getng-rg"
}