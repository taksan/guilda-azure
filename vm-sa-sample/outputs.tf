output "vm_ip_address" {
    value = azurerm_linux_virtual_machine.vm.public_ip_address
}

output "rg" {
    value = azurerm_resource_group.rg.name
}

output "keyvault-name" {
    value = azurerm_key_vault.kv.name
}