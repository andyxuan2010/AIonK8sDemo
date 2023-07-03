resource "azurerm_ssh_public_key" "emachine-pub-key" {
  name                = "emachine-pub-key"
  resource_group_name = azurerm_resource_group.challenge2-rg.name
  location            = var.location
  public_key          = var.emachine-pub-key
}
resource "azurerm_ssh_public_key" "vm-pub-key" {
  name                = "vm-pub-key"
  resource_group_name = azurerm_resource_group.challenge2-rg.name
  location            = var.location
  public_key          = var.vm-pub-key
}