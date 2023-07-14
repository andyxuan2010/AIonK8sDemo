output "resource_group_name" {
  value = azurerm_resource_group.challenge2-rg.name
}

# k8s jumpbox
output "pip-k8s" {
  value = azurerm_public_ip.pip-k8s.ip_address
}

output "hostname-k8s" {
  value = azurerm_dns_a_record.k8s.fqdn
}

#node pip created by itself
output "aks-node1-ip" {
  value = tolist(toset(azurerm_dns_a_record.n1.records))[0]
}

#LB pip created by ingress-nginx-controller
output "aks-demo" {
  value = tolist(toset(azurerm_dns_a_record.demo.records))[0]
}

output "aks_ep" {
  value = tolist(toset(azurerm_dns_a_record.ep.records))[0]
}

output "aks_fqdn" {
  value = azurerm_kubernetes_cluster.aks.fqdn
}


output "aks_node_rg" {
  value = azurerm_kubernetes_cluster.aks.node_resource_group
}

# output "acr_login_server" {
#   value = azurerm_container_registry.basfacr.login_server
# }



