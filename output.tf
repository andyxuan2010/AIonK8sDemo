output "resource_group_name" {
  value = azurerm_resource_group.challenge2-rg.name
}
output "pip-k8s" {
  value = azurerm_public_ip.pip-k8s.ip_address
}

