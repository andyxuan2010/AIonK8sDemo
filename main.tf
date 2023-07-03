
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


resource "azurerm_network_interface" "ni-vm" {
  name                = "ni-vm"
  location            = azurerm_resource_group.challenge2-rg.location
  resource_group_name = azurerm_resource_group.challenge2-rg.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.challenge2-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_virtual_machine" "k8svm" {
  name                  = "k8svm"
  location              = azurerm_resource_group.challenge2-rg.location
  resource_group_name   = azurerm_resource_group.challenge2-rg.name
  network_interface_ids = [azurerm_network_interface.ni-vm.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "k8svm"
    admin_username = "admin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = merge(var.common_tags, {
    name = "k8svm"
  })
}
