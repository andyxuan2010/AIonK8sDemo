# Create virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "virtual-network-${var.purpose["test"]}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    environment = "${var.purpose["test"]}"
  }
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-${var.purpose["test"]}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "public_ip" {
  name                = "public-ip-${var.purpose["test"]}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "${var.purpose["test"]}"
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = "network-security-group-${var.purpose["test"]}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "${var.purpose["test"]}"
  }
}

# Create network interface
resource "azurerm_network_interface" "nic" {
  name                = "network-interface-${var.purpose["test"]}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }

  tags = {
    environment = "${var.purpose["test"]}"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "association" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "diag-storage" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "${var.purpose["test"]}"
  }
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "linuxvm" {
  name                  = "linux-virtual-machine-${var.purpose["test"]}"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "linuxvmOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "myvm"
  admin_username                  = "azuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azuser"
    public_key = azurerm_ssh_public_key.smartgpt-ec2-key.public_key
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storage.primary_blob_endpoint
  }

  tags = {
    environment = "${var.purpose["test"]}"
  }
}






################### for windows VM & bastion
#------------------------------------------------------###################
# VNET & Subnets
#------------------------------------------------------###################

####################
# resource "azurerm_subnet" "winvm" {
#   name                 = var.subnet_name
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = ["10.0.0.0/24"]
# }

# resource "azurerm_subnet" "bastion" {
#   name                 = "AzureBastionSubnet"
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   #address_prefixes     = ["10.0.1.0/27"]
#   address_prefixes     = ["10.0.2.0/24"]
# }


#------------------------------------------------------###################
# VM for BASTION
#------------------------------------------------------###################

# resource "azurerm_network_interface" "winvm" {
#   name                = var.network_interface_name
#   location            = var.location
#   resource_group_name = azurerm_resource_group.rg.name

#   ip_configuration {
#     name                          = "myNicConfiguration"
#     subnet_id                     = azurerm_subnet.winvm.id
#     private_ip_address_allocation = "Dynamic"
#     # public_ip_address_id          = azurerm_public_ip.public_ip.id
#   }
# }

# resource "azurerm_windows_virtual_machine" "winvm" {
#   name                  = var.windows_vm_name
#   location              = var.location
#   resource_group_name   = azurerm_resource_group.rg.name
#   network_interface_ids = [azurerm_network_interface.winvm.id]
#   size                  = "Standard_DS1_v2"
#   admin_username        = "azuser"
#   admin_password        = "adminFC9"

#   os_disk {
#     name                 = "winvmOsDisk"
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "MicrosoftWindowsDesktop"
#     offer     = "Windows-10"
#     sku       = "20h1-pro-g2"
#     version   = "latest"
#   }
# }


#------------------------------------------------------###################
# BASTION
#------------------------------------------------------###################

# resource "azurerm_public_ip" "bastion" {
#   name                = "bastionip"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.rg.name
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }

# resource "azurerm_bastion_host" "bastion" {
#   name                = "bastion"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.rg.name

#   ip_configuration {
#     name                 = "configuration"
#     subnet_id            = azurerm_subnet.bastion.id
#     public_ip_address_id = azurerm_public_ip.bastion.id
#   }
# }
#--------------------------------------------------------------------------
# Install tools in Bastion VM
#--------------------------------------------------------------------------

// resource "azurerm_virtual_machine_extension" "extension" {
//   name                 = "k8s-tools-deploy"
//   virtual_machine_id   = azurerm_windows_virtual_machine.winvm.id
//   publisher            = "Microsoft.Azure.Extensions"
//   type                 = "CustomScript"
//   type_handler_version = "1.9.5" # "2.0"

//   settings = <<SETTINGS
//     {
//         "script": "hostname"
//     }
// SETTINGS

// //   settings = <<SETTINGS
// //     {
// //         "script": "hostname"
// //         # "commandToExecute": "hostname"
// //     }
// // SETTINGS
// }

// resource "azurerm_virtual_machine_extension" "extension" {
//   name                 = "k8s-tools-deploy01"
//   virtual_machine_id   = azurerm_windows_virtual_machine.winvm.id
//   publisher            = "Microsoft.Compute"
//   type                 = "CustomScriptExtension"
//   type_handler_version = "1.9.5" # "2.0"

//   settings = <<SETTINGS
//     {
//         "script": "hostname"
//     }
// SETTINGS

// //   settings = <<SETTINGS
// //     {
// //         "script": "hostname"
// //         # "commandToExecute": "hostname"
// //     }
// // SETTINGS
// }

# # Install Azure CLI
# Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi
#
# # Install chocolately
# Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
#
# # Install Kubernetes CLI
# choco install kubernetes-cli
#
# # Install Helm CLI
# choco install kubernetes-helm