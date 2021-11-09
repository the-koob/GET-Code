/*
resource "azurerm_managed_disk" "grid_work" {
  count                = 4
  name                 = "ggworkwal-disk-0${count.index}"
  location             = "East US"
  resource_group_name  = data.azurerm_resource_group.getng_rg.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = "512"
  tags = {
    aa-app-id           = "154900"
    aa-costcenter       = "0900/1577"
    aa-sdlc-environment = "nonprod"
    aa-security         = "reserved"
    disk-type           = "gridgain"
  }
}
resource "azurerm_managed_disk" "grid_arch" {
  count                = 4
  name                 = "ggwalarchive-disk-0${count.index}"
  location             = "East US"
  resource_group_name  = data.azurerm_resource_group.getng_rg.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = "512"
  tags = {
    aa-app-id           = "154900"
    aa-costcenter       = "0900/1577"
    aa-sdlc-environment = "nonprod"
    aa-security         = "reserved"
    disk-type           = "gridgain"
  }
}
resource "azurerm_managed_disk" "swim_work" {
  count                = 4
  name                 = "swimworkwal-disk-0${count.index}"
  location             = "East US"
  resource_group_name  = data.azurerm_resource_group.getng_rg.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = "512"
  tags = {
    aa-app-id           = "154900"
    aa-costcenter       = "0900/1577"
    aa-sdlc-environment = "nonprod"
    aa-security         = "reserved"
    disk-type           = "gridgain"
  }
}
resource "azurerm_managed_disk" "swim_arch" {
  count                = 4
  name                 = "swimwalarchive-disk-0${count.index}"
  location             = "East US"
  resource_group_name  = data.azurerm_resource_group.getng_rg.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = "512"
  tags = {
    aa-app-id           = "154900"
    aa-costcenter       = "0900/1577"
    aa-sdlc-environment = "nonprod"
    aa-security         = "reserved"
    disk-type           = "gridgain"
  }
}

resource "azurerm_managed_disk" "apt_work" {
  count                = 4
  name                 = "aptworkwal-disk-0${count.index}"
  location             = "East US"
  resource_group_name  = data.azurerm_resource_group.getng_rg.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = "128"
  tags = {
    aa-app-id           = "154900"
    aa-costcenter       = "0900/1577"
    aa-sdlc-environment = "nonprod"
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
  disk_size_gb         = "128"
  tags = {
    aa-app-id           = "154900"
    aa-costcenter       = "0900/1577"
    aa-sdlc-environment = "nonprod"
    aa-security         = "reserved"
    disk-type           = "gridgain"
  }
}
*/
resource "azurerm_kubernetes_cluster" "getng_aks" {
  name                = "ct-n-zeaus-getng-aks"
  location            = "eastus"
  resource_group_name = data.azurerm_resource_group.getng_rg.name
  dns_prefix          = "getng-n-aks"
  #node_resource_group = azurerm_kubernetes_cluster.getng_aks.name
  kubernetes_version  = "1.19.6"
  
  role_based_access_control {
    enabled = true
    azure_active_directory {
        client_app_id     = "dbdd928e-dd2f-4a55-ada5-09cb7784b164"
        server_app_id     = "b52fb14c-c9f8-467b-bed9-7613f5ac4dea"
        server_app_secret = "[1c?OLFwA0c7r?.B6exlrSIVo7SRUgfl"
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
    client_id     = "b52fb14c-c9f8-467b-bed9-7613f5ac4dea"
    client_secret = "[1c?OLFwA0c7r?.B6exlrSIVo7SRUgfl"
  }

  addon_profile {
    oms_agent {
    enabled                    = true
    log_analytics_workspace_id = "/subscriptions/0bc507f3-ad14-4edd-8f76-a91458390da2/resourceGroups/ct-n-zeaus-getng-rg/providers/Microsoft.OperationalInsights/workspaces/ct-n-zeaus-getng-law"
    }
    kube_dashboard {
      enabled = false
    }
  }

  default_node_pool {
    name                = "getngpool"
    #node_count          = 4
    enable_auto_scaling = true
    max_count           = 8
    max_pods            = 30
    min_count           = 3
    os_disk_size_gb     = 512
    type                = "VirtualMachineScaleSets"
    vm_size             = "Standard_E8s_v3"
    vnet_subnet_id      = "/subscriptions/0bc507f3-ad14-4edd-8f76-a91458390da2/resourceGroups/ets-p-zeaus-network-rg/providers/Microsoft.Network/virtualNetworks/ct-n-zeaus-10.226.96.0_19-vnet/subnets/ct-n-zeaus-getng-aks-10.226.110.0_23-sub"
  }
  
  tags = {
    aa-product-id       = "getng"
    aa-app-id           = "154900"
    aa-costcenter       = "0900/1577"
    aa-sdlc-environment = "nonprod"
    aa-security         = "reserved"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "ggpool_a" {
  name                  = "ggpool01"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.getng_aks.id
  vm_size               = "Standard_E8s_v3"
  enable_auto_scaling   = true
  min_count             = 2
  max_count             = 4
  
  node_taints           = ["workload=gridgain:NoSchedule"]
  node_labels           = { 
    
    "workload" = "gridgain"
  }

  os_disk_size_gb       = 512
  vnet_subnet_id        = "/subscriptions/0bc507f3-ad14-4edd-8f76-a91458390da2/resourceGroups/ets-p-zeaus-network-rg/providers/Microsoft.Network/virtualNetworks/ct-n-zeaus-10.226.96.0_19-vnet/subnets/ct-n-zeaus-getng-aks-10.226.110.0_23-sub"
}

resource "azurerm_kubernetes_cluster_node_pool" "swimpool_a" {
  name                  = "swimpool01"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.getng_aks.id
  vm_size               = "Standard_E8s_v3"
  enable_auto_scaling   = true
  min_count             = 2
  max_count             = 4
  
  node_taints           = ["workload=swim:NoSchedule"]
  node_labels           = { 
    
    "workload" = "swim"
  }
  
  os_disk_size_gb       = 512
  vnet_subnet_id        = "/subscriptions/0bc507f3-ad14-4edd-8f76-a91458390da2/resourceGroups/ets-p-zeaus-network-rg/providers/Microsoft.Network/virtualNetworks/ct-n-zeaus-10.226.96.0_19-vnet/subnets/ct-n-zeaus-getng-aks-10.226.110.0_23-sub"
  }

resource "azurerm_kubernetes_cluster_node_pool" "ggpool_b" {
  name                  = "ggpool02"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.getng_aks.id
  vm_size               = "Standard_E8s_v3"
  enable_auto_scaling   = true
  min_count             = 2
  max_count             = 4
  
  node_taints           = ["workload=gridgain:NoSchedule"]
  node_labels           = { 
    
    "workload" = "gridgain"
  }

  os_disk_size_gb       = 512
  vnet_subnet_id        = "/subscriptions/0bc507f3-ad14-4edd-8f76-a91458390da2/resourceGroups/ets-p-zeaus-network-rg/providers/Microsoft.Network/virtualNetworks/ct-n-zeaus-10.226.96.0_19-vnet/subnets/ct-n-zeaus-getng-aks-10.226.110.0_23-sub"
  }

resource "azurerm_kubernetes_cluster_node_pool" "swimpool_b" {
  name                  = "swimpool02"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.getng_aks.id
  vm_size               = "Standard_E8s_v3"
  enable_auto_scaling   = true
  min_count             = 2
  max_count             = 4
  
  node_taints           = ["workload=swim:NoSchedule"]
  node_labels           = { 
    
    "workload" = "swim"
  }
  
  os_disk_size_gb       = 512
  vnet_subnet_id        = "/subscriptions/0bc507f3-ad14-4edd-8f76-a91458390da2/resourceGroups/ets-p-zeaus-network-rg/providers/Microsoft.Network/virtualNetworks/ct-n-zeaus-10.226.96.0_19-vnet/subnets/ct-n-zeaus-getng-aks-10.226.110.0_23-sub"
}
*/
/*
resource "azurerm_kubernetes_cluster_node_pool" "apt360pool_a" {
  name                  = "apt360pool01"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.getng_aks.id
  vm_size               = "Standard_E8s_v3"
  enable_auto_scaling   = true
  min_count             = 2
  max_count             = 4
  
  node_taints           = ["workload=apt360:NoSchedule"]
  node_labels           = { 
    
    "workload" = "apt360"
  }
  
  os_disk_size_gb       = 512
  vnet_subnet_id        = "/subscriptions/0bc507f3-ad14-4edd-8f76-a91458390da2/resourceGroups/ets-p-zeaus-network-rg/providers/Microsoft.Network/virtualNetworks/ct-n-zeaus-10.226.96.0_19-vnet/subnets/ct-n-zeaus-getng-aks-10.226.110.0_23-sub"
  }
  */
/*
resource "azurerm_kubernetes_cluster_node_pool" "apt360pool_b" {
  name                  = "apt360pool02"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.getng_aks.id
  vm_size               = "Standard_E8s_v3"
  enable_auto_scaling   = true
  min_count             = 2
  max_count             = 4
  
  node_taints           = ["workload=apt360:NoSchedule"]
  node_labels           = { 
    
    "workload" = "apt360"
  }
  
  os_disk_size_gb       = 512
  vnet_subnet_id        = "/subscriptions/0bc507f3-ad14-4edd-8f76-a91458390da2/resourceGroups/ets-p-zeaus-network-rg/providers/Microsoft.Network/virtualNetworks/ct-n-zeaus-10.226.96.0_19-vnet/subnets/ct-n-zeaus-getng-aks-10.226.110.0_23-sub"
  }

# ------  OUT TO .OUT File in terraform command string
output "client_certificate" {
  value = azurerm_kubernetes_cluster.getng_aks.kube_config.0.client_certificate
}
output "kube_config" {
  value = azurerm_kubernetes_cluster.getng_aks.kube_config_raw
}
*/