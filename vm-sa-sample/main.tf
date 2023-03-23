provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  location = "eastus"
  name     = "sometake"
}

module "myip" {
  source = "github.com/taksan/terraform-myip"
}

data "azurerm_client_config" "current" {}