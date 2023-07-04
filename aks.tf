resource "azurerm_kubernetes_cluster" "aks" {
  name                = "challenge-aks"
  kubernetes_version  = "1.19.3"
  location            = azurerm_resource_group.challenge2-rg.location
  resource_group_name = azurerm_resource_group.challenge2-rg.name
  dns_prefix          = "basf"
  node_resource_group = azurerm_resource_group.challenge2-rg

  default_node_pool {
    name                = "system"
    node_count          = 3
    vm_size             = "Standard_DS2_v2"
    type                = "VirtualMachineScaleSets"
    availability_zones  = [1, 2, 3]
    enable_auto_scaling = false
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    load_balancer_sku = "Standard"
    network_plugin    = "kubenet" # azure (CNI)
  }
}