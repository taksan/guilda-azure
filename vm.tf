resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "VM"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location

  network_interface_ids = [azurerm_network_interface.vm_nic.id]
  size                  = "Standard_B1s"

  os_disk {
    name                 = "vm-disk"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = "50"
    caching              = "ReadWrite"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"  
  }

  computer_name                   = "my-vm"
  admin_username                  = "ubuntu" 
  disable_password_authentication = true

  admin_ssh_key {
    username   = "ubuntu"
    public_key = tls_private_key.admin_ssh.public_key_openssh
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_network_interface" "vm_nic" {
  name                = "vm-nic"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "vm-ip-config"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
  }
}

resource "azurerm_public_ip" "vm_public_ip" {
  name                = "vm-public-ip"
  allocation_method   = "Dynamic"

  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
}

resource "azurerm_key_vault_access_policy" "catalog_vm_ap" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id = azurerm_linux_virtual_machine.vm.identity[0].tenant_id
  object_id = azurerm_linux_virtual_machine.vm.identity[0].principal_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete"
  ]
  depends_on = [
    azurerm_linux_virtual_machine.vm
  ]
}