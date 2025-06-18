data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "main" {
  name     = "tinman-poc-rg"
  location = var.location
}

resource "azurerm_key_vault" "main" {
  name                        = var.key_vault_name
  location                    = azurerm_resource_group.main.location
  resource_group_name         = azurerm_resource_group.main.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"

  purge_protection_enabled    = false
}

# Access policy for current user
resource "azurerm_key_vault_access_policy" "current_user" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Recover",
    "Backup",
    "Restore"
  ]
}

# Create Key Vault secrets with placeholder values
resource "azurerm_key_vault_secret" "supabase_url" {
  name         = "supabase-url"
  value        = "PLACEHOLDER_SUPABASE_URL"
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "supabase_anon_key" {
  name         = "supabase-anon-key"
  value        = "PLACEHOLDER_SUPABASE_ANON_KEY"
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "supabase_service_role_key" {
  name         = "supabase-service-role-key"
  value        = "PLACEHOLDER_SUPABASE_SERVICE_ROLE_KEY"
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "supabase_database_password" {
  name         = "supabase-database-password"
  value        = "PLACEHOLDER_SUPABASE_DATABASE_PASSWORD"
  key_vault_id = azurerm_key_vault.main.id
}
