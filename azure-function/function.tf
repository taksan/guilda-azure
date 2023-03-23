resource "azurerm_linux_function_app" "a-function" {
  name                = var.function_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  storage_account_name       = azurerm_storage_account.function_sa.name
  storage_account_access_key = azurerm_storage_account.function_sa.primary_access_key
  service_plan_id            = azurerm_service_plan.order_function_service_plan.id

  site_config {
    application_stack {
      node_version = 16
    }
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = var.runtime,
    WEBSITE_MOUNT_ENABLED = 1
  }

  lifecycle {
    ignore_changes = [
      site_config[0].application_insights_key,
      app_settings["APPINSIGHTS_INSTRUMENTATIONKEY"],
      app_settings["WEBSITE_RUN_FROM_PACKAGE"]
    ]
  }
}

resource "azurerm_storage_account" "function_sa" {
  name                     = var.function_storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "order_function_service_plan" {
  name                = "${var.function_name}-func-service-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_storage_container" "function_container" {
  name                 = "function-releases"
  storage_account_name = azurerm_storage_account.function_sa.name
}

