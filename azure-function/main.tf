provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  location = "eastus"
  name     = var.resourcegroup
}
