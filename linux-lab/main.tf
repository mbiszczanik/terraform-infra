terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "D-LinuxLab-NEu-RG01" {
  name     = "D-LinuxLab-NEu-RG01"
  location = "North Europe"
  tags = {
    Environment    = "D"
    Infrastructure = "Common"
    Location       = "North Europe"
  }
}

# VNet for networking purposes
resource "azurerm_virtual_network" "D-LinuxLab-NEu-VNet01" {
  name                = "D-LinuxLab-NEu-VNet01"
  resource_group_name = azurerm_resource_group.D-LinuxLab-NEu-RG01.name
  location            = azurerm_resource_group.D-LinuxLab-NEu-RG01.location
  address_space       = ["10.123.0.0/16"]

  tags = {
    Environment    = "D"
    Infrastructure = "Common"
    Location       = "North Europe"
  }
}

# Subnet
resource "azurerm_subnet" "BackendSubnet" {
  name                 = "BackendSubnet"
  resource_group_name  = azurerm_resource_group.D-LinuxLab-NEu-RG01.name
  virtual_network_name = azurerm_virtual_network.D-LinuxLab-NEu-VNet01.name
  address_prefixes     = ["10.123.1.0/24"]
}

resource "azurerm_network_security_group" "D-LinuxLab-NEu-NSG01" {
  name                = "D-LinuxLab-NEu-NSG01"
  location            = azurerm_resource_group.D-LinuxLab-NEu-RG01.location
  resource_group_name = azurerm_resource_group.D-LinuxLab-NEu-RG01.name

  tags = {
    Environment    = "D"
    Infrastructure = "Common"
    Location       = "North Europe"
  }
}

resource "azurerm_network_security_rule" "Dev-rule" {
  name                        = "Dev-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.D-LinuxLab-NEu-RG01.name
  network_security_group_name = azurerm_network_security_group.D-LinuxLab-NEu-NSG01.name
}

resource "azurerm_subnet_network_security_group_association" "Dev-sga" {
  subnet_id                 = azurerm_subnet.BackendSubnet.id
  network_security_group_id = azurerm_network_security_group.D-LinuxLab-NEu-NSG01.id
}

resource "azurerm_public_ip" "D-LinuxLab-NEu-PIP01" {
  name                = "D-LinuxLab-NEu-PIP01"
  resource_group_name = azurerm_resource_group.D-LinuxLab-NEu-RG01.name
  location            = azurerm_resource_group.D-LinuxLab-NEu-RG01.location
  allocation_method   = "Dynamic"
  tags = {
    Environment    = "D"
    Infrastructure = "Common"
    Location       = "North Europe"
  }
}

resource "azurerm_network_interface" "D-LinuxLab-NEu-NIC01" {
  name                = "D-LinuxLab-NEu-NIC01"
  location            = azurerm_resource_group.D-LinuxLab-NEu-RG01.location
  resource_group_name = azurerm_resource_group.D-LinuxLab-NEu-RG01.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.BackendSubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.D-LinuxLab-NEu-PIP01.id
  }
  tags = {
    Environment    = "D"
    Infrastructure = "Common"
    Location       = "North Europe"
  }
}

resource "azurerm_linux_virtual_machine" "D-LinuxLab-NEu-VM01" {
  name                  = "D-LinuxLab-NEu-VM01"
  resource_group_name   = azurerm_resource_group.D-LinuxLab-NEu-RG01.name
  location              = azurerm_resource_group.D-LinuxLab-NEu-RG01.location
  size                  = "Standard_B1s"
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.D-LinuxLab-NEu-NIC01.id]

  # Azure is expecting 64
  custom_data = filebase64("customdata.tpl")

  # Create keygen
  # ssh-keygen -t rsa
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/D-LinuxLab-key.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # az vm image list -f Ubuntu  
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  provisioner "local-exec" {
    command = templatefile("${var.host_os}-ssh-script.tpl", {
      hostname     = self.public_ip_address,
      user         = "adminuser",
      identityfile = "~/.ssh/D-LinuxLab-key"
    })
    interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]
  }

  tags = {
    Environment    = "D"
    Infrastructure = "Common"
    Location       = "North Europe"
  }
}

# terraform state list
# terraform state show azurerm_linux_virtual_machine.D-LinuxLab-NEu-VM01
# ssh -i C:\Users\mbiszczanik\.ssh\D-LinuxLab-key adminuser@XX.XX.XX.XX

data "azurerm_public_ip" "D-LinuxLab-data" {
  name                = azurerm_public_ip.D-LinuxLab-NEu-PIP01.name
  resource_group_name = azurerm_resource_group.D-LinuxLab-NEu-RG01.name
}

output "public_ip_address" {
  value = "${azurerm_linux_virtual_machine.D-LinuxLab-NEu-VM01.name}: ${data.azurerm_public_ip.D-LinuxLab-data.ip_address}"
}