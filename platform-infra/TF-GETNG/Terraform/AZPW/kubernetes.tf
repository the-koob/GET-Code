
#  This plan assumes that the Vnet and Subnet are already in place.

#  You will need 2 service principals from Azure AD for true RBAC (AD) integration.

#  One sp is the "server sp" and one is the "client sp"

# The SERVER SP will need the following API permissions:
#     - Graph > Application > Directory.Read.All
#     - Graph > Delegated > Directory.Read.All
#     - Graph > Delegated > User.Read

# CLIENT SP Manifest needs the following settings:
#     "allowPublicClient": true,
#     "oauth2AllowIdTokenImplicitFlow": true

# You may use advanced networking where the virtual network and subnet or public IP addresses are in another resource group. Assign one of the following set of role permissions:
#   Create a custom role and define the following role permissions:
#   Microsoft.Network/virtualNetworks/subnets/join/action
#   Microsoft.Network/virtualNetworks/subnets/read
#   Microsoft.Network/virtualNetworks/subnets/write
#   Microsoft.Network/publicIPAddresses/join/action
#   Microsoft.Network/publicIPAddresses/read
#   Microsoft.Network/publicIPAddresses/write
#   Or, assign the Network Contributor built-in role on the subnet within the virtual network
#
#     SAUCE: https://docs.microsoft.com/en-us/azure/aks/kubernetes-service-principal

#  Within this code, you will see "client_id" and similar variables.

#  Please see .\release.txt for explanation of the use of SPs.

#  Section 1 indicates the prerequistes for the use of this deployment code.

#  For now, the azure_active_directory block contains plain text variables
#=====================================================


resource "azurerm_managed_disk" "grid_work" {
  count                = 4
  name                 = "ggworkwal-disk-0${count.index}"
  location             = "West US"
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
resource "azurerm_managed_disk" "grid_arch" {
  count                = 4
  name                 = "ggwalarchive-disk-0${count.index}"
  location             = "West US"
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
resource "azurerm_managed_disk" "swim_work" {
  count                = 4
  name                 = "swimworkwal-disk-0${count.index}"
  location             = "West US"
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
resource "azurerm_managed_disk" "swim_arch" {
  count                = 4
  name                 = "swimwalarchive-disk-0${count.index}"
  location             = "West US"
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

resource "azurerm_managed_disk" "apt_work" {
  count                = 4
  name                 = "aptworkwal-disk-0${count.index}"
  location             = "West US"
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
  location             = "West US"
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

resource "azurerm_kubernetes_cluster" "getng_aks" {
  name                = "ct-p-zweus-getng-aks"
  location            = "westus"
  resource_group_name = "ct-p-zweus-getng-rg"
  dns_prefix          = "getng-p-aks"

  kubernetes_version  = "1.20.5"
  
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
    log_analytics_workspace_id = "/subscriptions/d468b5ca-4400-4521-8115-2bba3467f651/resourceGroups/ct-p-zweus-getng-rg/providers/Microsoft.OperationalInsights/workspaces/ct-p-zweus-getng-law"
    }
  }

  default_node_pool {
    name                = "getngpool"
    #node_count          = 3
    enable_auto_scaling = true
    max_count           = 8
    max_pods            = 30
    min_count           = 3
    os_disk_size_gb     = 512
    type                = "VirtualMachineScaleSets"
    vm_size             = "Standard_E8s_v3"
    vnet_subnet_id      = "/subscriptions/d468b5ca-4400-4521-8115-2bba3467f651/resourceGroups/ets-p-zweus-network-rg/providers/Microsoft.Network/virtualNetworks/ct-p-zweus-10.147.96.0_19-vnet/subnets/ct-p-zweus-getng-aks-10.147.124.0_22-sub"
  }
  tags = {
    aa-app-id           = "154900"
    aa-costcenter       = "0900/1577"
    aa-sdlc-environment = "prod"
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
  vnet_subnet_id      = "/subscriptions/d468b5ca-4400-4521-8115-2bba3467f651/resourceGroups/ets-p-zweus-network-rg/providers/Microsoft.Network/virtualNetworks/ct-p-zweus-10.147.96.0_19-vnet/subnets/ct-p-zweus-getng-aks-10.147.124.0_22-sub"
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
  vnet_subnet_id      = "/subscriptions/d468b5ca-4400-4521-8115-2bba3467f651/resourceGroups/ets-p-zweus-network-rg/providers/Microsoft.Network/virtualNetworks/ct-p-zweus-10.147.96.0_19-vnet/subnets/ct-p-zweus-getng-aks-10.147.124.0_22-sub"
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
  vnet_subnet_id      = "/subscriptions/d468b5ca-4400-4521-8115-2bba3467f651/resourceGroups/ets-p-zweus-network-rg/providers/Microsoft.Network/virtualNetworks/ct-p-zweus-10.147.96.0_19-vnet/subnets/ct-p-zweus-getng-aks-10.147.124.0_22-sub"
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
  vnet_subnet_id      = "/subscriptions/d468b5ca-4400-4521-8115-2bba3467f651/resourceGroups/ets-p-zweus-network-rg/providers/Microsoft.Network/virtualNetworks/ct-p-zweus-10.147.96.0_19-vnet/subnets/ct-p-zweus-getng-aks-10.147.124.0_22-sub"
}

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
  vnet_subnet_id      = "/subscriptions/d468b5ca-4400-4521-8115-2bba3467f651/resourceGroups/ets-p-zweus-network-rg/providers/Microsoft.Network/virtualNetworks/ct-p-zweus-10.147.96.0_19-vnet/subnets/ct-p-zweus-getng-aks-10.147.124.0_22-sub"
  }

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
  vnet_subnet_id      = "/subscriptions/d468b5ca-4400-4521-8115-2bba3467f651/resourceGroups/ets-p-zweus-network-rg/providers/Microsoft.Network/virtualNetworks/ct-p-zweus-10.147.96.0_19-vnet/subnets/ct-p-zweus-getng-aks-10.147.124.0_22-sub"
  }



# ------  OUT TO .OUT File in terraform command string
output "client_certificate" {
  value = azurerm_kubernetes_cluster.getng_aks.kube_config.0.client_certificate
}
output "kube_config" {
  value = azurerm_kubernetes_cluster.getng_aks.kube_config_raw
}
