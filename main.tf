provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  location = "eastus"
  name     = "sometake"
}

data "azurerm_client_config" "current" {}