terraform {
  backend "azurerm" {
    resource_group_name  = "tinman-tfstate-rg"
    storage_account_name = "tinmantfstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
} 