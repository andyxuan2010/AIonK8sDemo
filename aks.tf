# resource "azurerm_container_registry" "basfacr" {
#   name                = "basfacr"
#   resource_group_name = azurerm_resource_group.challenge2-rg.name
#   location            = azurerm_resource_group.challenge2-rg.location
#   sku                 = "Standard"
#   admin_enabled       = false
# }
# resource "azurerm_role_assignment" "basf-aks-role" {
#   principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
#   role_definition_name             = "AcrPull"
#   scope                            = azurerm_container_registry.basfacr.id
#   skip_service_principal_aad_check = true
# }
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "challenge-aks"
  kubernetes_version  = "1.26.3"
  location            = azurerm_resource_group.challenge2-rg.location
  resource_group_name = azurerm_resource_group.challenge2-rg.name
  sku_tier            = "Free"
  dns_prefix          = "basf"
  #node_resource_group = azurerm_resource_group.aks-rg.name

  default_node_pool {
    name = "system"
    #vm_size             = "Standard_DS2_v2"
    vm_size               = "standard_b2s"
    type                  = "VirtualMachineScaleSets"
    enable_auto_scaling   = false
    enable_node_public_ip = true
    node_count            = 1
    # enable_auto_scaling = true
    # node_count = 2
    # max_count = 2
    # min_count = 1
    vnet_subnet_id = azurerm_subnet.challenge2-subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    load_balancer_sku = "basic"
    #network_plugin    = "kubenet" # azure (CNI)
    network_plugin = "azure"
  }
  #depends_on = [azurerm_resource_group.aks-rg]
}

# resource "local_file" "kubeconfig" {
#   depends_on = [azurerm_kubernetes_cluster.aks]
#   filename = "kubeconfig"
#   content = azurerm_kubernetes_cluster.aks.kube_config_raw
# }
