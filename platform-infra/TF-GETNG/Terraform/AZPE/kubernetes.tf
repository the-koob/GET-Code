resource "azurerm_kubernetes_cluster_node_pool" "apt360pool_a" {
  name                  = "apt360pool01"
  kubernetes_cluster_id = data.azurerm_kubernetes_cluster.getng_aks.id
  vm_size               = "Standard_E8s_v3"
  enable_auto_scaling   = true
  min_count             = 2
  max_count             = 4
  
  node_taints           = ["workload=apt360:NoSchedule"]
  node_labels           = { 
    
    "workload" = "apt360"
  }
  
  os_disk_size_gb       = 512
  vnet_subnet_id      = "/subscriptions/d468b5ca-4400-4521-8115-2bba3467f651/resourceGroups/ets-p-zeaus-network-rg/providers/Microsoft.Network/virtualNetworks/ct-p-zeaus-10.227.96.0_19-vnet/subnets/ct-p-zeaus-getng-aks-10.227.124.0_22-sub"
  }

resource "azurerm_kubernetes_cluster_node_pool" "apt360pool_b" {
  name                  = "apt360pool02"
  kubernetes_cluster_id = data.azurerm_kubernetes_cluster.getng_aks.id
  vm_size               = "Standard_E8s_v3"
  enable_auto_scaling   = true
  min_count             = 2
  max_count             = 4
  
  node_taints           = ["workload=apt360:NoSchedule"]
  node_labels           = { 
    
    "workload" = "apt360"
  }
  
  os_disk_size_gb       = 512
  vnet_subnet_id      = "/subscriptions/d468b5ca-4400-4521-8115-2bba3467f651/resourceGroups/ets-p-zeaus-network-rg/providers/Microsoft.Network/virtualNetworks/ct-p-zeaus-10.227.96.0_19-vnet/subnets/ct-p-zeaus-getng-aks-10.227.124.0_22-sub"
  }

resource "azurerm_managed_disk" "apt_work" {
  count                = 4
  name                 = "aptworkwal-disk-0${count.index}"
  location             = "East US"
  resource_group_name  = data.azurerm_resource_group.getng_rg.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = "256"
  tags = {
    aa-app-id           = "154900"
    aa-costcenter       = "0900/1577"
    aa-sdlc-environment = "prod"
    aa-security         = "reserved"
    disk-type           = "gridgain"
  }
}
  resource "azurerm_managed_disk" "apt_arch" {
  count                = 4
  name                 = "aptwalarchive-disk-0${count.index}"
  location             = "East US"
  resource_group_name  = data.azurerm_resource_group.getng_rg.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = "256"
  tags = {
    aa-app-id           = "154900"
    aa-costcenter       = "0900/1577"
    aa-sdlc-environment = "prod"
    aa-security         = "reserved"
    disk-type           = "gridgain"
  }
}



/*
resource "azurerm_kubernetes_cluster" "getng_aks" {
  name                = "ct-p-zeaus-getng-aks2"
  location            = "eastus"
  resource_group_name = "ct-p-zeaus-getng-rg"
  dns_prefix          = "getng-akstest"
  #node_resource_group = azurerm_kubernetes_cluster.getng_aks.name
  kubernetes_version  = "1.19.6"
  
    role_based_access_control {
    enabled = true
    azure_active_directory {
        client_app_id     = "421b6fe9-1cd4-450a-af99-a1ccf1094449"
        server_app_id     = "54b89883-7a12-433b-a841-36f1ebb1fcfd"
        server_app_secret = "=oyQLX[7Z:-o7uC4BC6[.LsznVclX?Jv"
        tenant_id         = "49793faf-eb3f-4d99-a0cf-aef7cce79dc1"
    }
  }
  network_profile {
    dns_service_ip      = "100.127.240.9"
    docker_bridge_cidr  = "172.17.0.1/16"
    #load_balancer_sku  = "Basic"
    outbound_type       = "userDefinedRouting"
    network_plugin      = "azure"
    network_policy      = "calico"
    service_cidr        = "100.127.240.0/20"
  }

  service_principal {
    client_id     = "54b89883-7a12-433b-a841-36f1ebb1fcfd"
    client_secret = "=oyQLX[7Z:-o7uC4BC6[.LsznVclX?Jv"
  }

  addon_profile {
    oms_agent {
    enabled                    = true
    log_analytics_workspace_id = "/subscriptions/d468b5ca-4400-4521-8115-2bba3467f651/resourceGroups/ct-p-zeaus-getng-rg/providers/Microsoft.OperationalInsights/workspaces/ct-p-getng-aks-law"
    }
    kube_dashboard {
      enabled                  = false
    }
  }

  default_node_pool {
    name                = "getngtest"
    #node_count          = 5
    enable_auto_scaling = true
    max_count           = 8
    max_pods            = 30
    min_count           = 3
    os_disk_size_gb     = 512
    type                = "VirtualMachineScaleSets"
    vm_size             = "Standard_E8s_v3"
    vnet_subnet_id      = "/subscriptions/d468b5ca-4400-4521-8115-2bba3467f651/resourceGroups/ets-p-zeaus-network-rg/providers/Microsoft.Network/virtualNetworks/ct-p-zeaus-10.227.96.0_19-vnet/subnets/ct-p-zeaus-getng-aks-10.227.124.0_22-sub"
  }
  
  tags = {
    aa-product-id       = "getng"
    aa-app-id           = "154900"
    aa-costcenter       = "0900/1577"
    aa-sdlc-environment = "prod"
    aa-security         = "reserved"
  }
}
*/
