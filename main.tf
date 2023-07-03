
resource "azurerm_resource_group" "challenge2-rg" {
  name     = "challenge2-rg"
  location = "West Europe"
  tags = merge(var.common_tags, {
    name = "challenge2-rg"
  })
}
resource "azurerm_virtual_network" "challenge2-vnet" {
  name                = "challenge2-vnet"
  address_space       = ["10.10.0.0/16"]
  location            = azurerm_resource_group.challenge2-rg.location
  resource_group_name = azurerm_resource_group.challenge2-rg.name
  tags = merge(var.common_tags, {
    name = "challenge2-vnet"
  })
}
resource "azurerm_subnet" "challenge2-subnet" {
  name                 = "challenge2-subnet"
  resource_group_name  = azurerm_resource_group.challenge2-rg.name
  virtual_network_name = azurerm_virtual_network.challenge2-vnet.name
  address_prefixes     = ["10.10.1.0/24"]
}
