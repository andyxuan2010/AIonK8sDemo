output "resource_group_name" {
  value = azurerm_resource_group.challenge2-rg.name
}
output "pip-k8s" {
  value = azurerm_public_ip.pip-k8s.ip_address
}
output "hostname-k8s" {
  value = azurerm_dns_a_record.k8s.fqdn
}


# output "aks_id" {
#   value = azurerm_kubernetes_cluster.aks.id
# }

# output "aks_fqdn" {
#   value = azurerm_kubernetes_cluster.aks.fqdn
# }

# output "aks_node_rg" {
#   value = azurerm_kubernetes_cluster.aks.node_resource_group
# }