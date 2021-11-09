/*
az aks get-upgrades -g ct-n-zeaus-getng-rg -n ct-n-zeaus-getng-aks

az aks nodepool list -g ct-n-zeaus-getng-rg --cluster-name ct-n-zeaus-getng-aks
az aks show -g ct-n-zeaus-getng-rg -n ct-n-zeaus-getng-aks
az aks upgrade \
    -g ct-n-zeaus-getng-rg \
    -n ct-n-zeaus-getng-aks \
    --kubernetes-version "1.20.5" \
    --no-wait


az aks nodepool upgrade \
    -g ct-n-zeaus-getng-rg \
    --cluster-name ct-n-zeaus-getng-aks \
    --name apt360pool01 \
    --kubernetes-version 1.20.5 \
    --no-wait




*/



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

