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

# Azure AD Service Principal for GitHub Actions
resource "azuread_application" "github_actions" {
  display_name = "tinman-github-actions"
  
  web {
    redirect_uris = [
      "https://token.actions.githubusercontent.com/"
    ]
  }
}

resource "azuread_service_principal" "github_actions" {
  application_id = azuread_application.github_actions.application_id
}

resource "azuread_service_principal_password" "github_actions" {
  service_principal_id = azuread_service_principal.github_actions.id
}

# Role assignment for the service principal
resource "azurerm_role_assignment" "github_actions" {
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.github_actions.object_id
}

# Federated identity credential for GitHub Actions OIDC
resource "azuread_application_federated_identity_credential" "github_actions" {
  application_object_id = azuread_application.github_actions.object_id
  display_name          = "github-actions"
  description           = "GitHub Actions OIDC"
  audiences             = ["api://AzureADTokenExchange"]
  issuer                = "https://token.actions.githubusercontent.com"
  subject               = "repo:scott-lever/tinman:ref:refs/heads/main"
}

# Store GitHub Actions service principal credentials in Key Vault
resource "azurerm_key_vault_secret" "github_actions_client_id" {
  name         = "github-actions-client-id"
  value        = azuread_application.github_actions.application_id
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "github_actions_client_secret" {
  name         = "github-actions-client-secret"
  value        = azuread_service_principal_password.github_actions.value
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "github_actions_tenant_id" {
  name         = "github-actions-tenant-id"
  value        = data.azurerm_client_config.current.tenant_id
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "github_actions_subscription_id" {
  name         = "github-actions-subscription-id"
  value        = data.azurerm_client_config.current.subscription_id
  key_vault_id = azurerm_key_vault.main.id
}

# Azure OpenAI Cognitive Services Account
resource "azurerm_cognitive_account" "openai" {
  name                = "tinman-openai"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  kind                = "OpenAI"
  sku_name            = "S0"  # Standard tier

  custom_subdomain_name = "tinman-openai-20250619"

  network_acls {
    default_action = "Allow"
  }

  tags = {
    Environment = "POC"
    Project     = "Tinman"
  }
}

# Azure OpenAI GPT-4.1 Deployment
resource "azurerm_cognitive_deployment" "gpt41" {
  name                 = "tinman-gpt41"
  cognitive_account_id = azurerm_cognitive_account.openai.id

  model {
    format  = "OpenAI"
    name    = "gpt-4.1"
    version = "2025-04-14"
  }

  scale {
    type     = "GlobalStandard"
    capacity = 1
  }

  rai_policy_name = "Microsoft.Default"
}

# Azure Storage Account for blob storage
resource "azurerm_storage_account" "main" {
  name                     = "tinmanpocstorage"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  # Enable blob public access for easier development (can be disabled later)
  allow_nested_items_to_be_public = false

  # Enable versioning for data protection
  blob_properties {
    versioning_enabled = true
  }

  tags = {
    Environment = "POC"
    Project     = "Tinman"
  }
}

# Blob containers for different purposes
resource "azurerm_storage_container" "raw_uploads" {
  name                  = "raw-uploads"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "processed" {
  name                  = "processed"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "errors" {
  name                  = "errors"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "archives" {
  name                  = "archives"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
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

# Azure OpenAI API Key (will be stored in Key Vault)
resource "azurerm_key_vault_secret" "openai_api_key" {
  name         = "openai-api-key"
  value        = azurerm_cognitive_account.openai.primary_access_key
  key_vault_id = azurerm_key_vault.main.id
}

# Azure OpenAI Endpoint
resource "azurerm_key_vault_secret" "openai_endpoint" {
  name         = "openai-endpoint"
  value        = azurerm_cognitive_account.openai.endpoint
  key_vault_id = azurerm_key_vault.main.id
}

# Azure Storage Account Connection String
resource "azurerm_key_vault_secret" "storage_connection_string" {
  name         = "storage-connection-string"
  value        = azurerm_storage_account.main.primary_connection_string
  key_vault_id = azurerm_key_vault.main.id
}

# Azure Storage Account Access Key
resource "azurerm_key_vault_secret" "storage_access_key" {
  name         = "storage-access-key"
  value        = azurerm_storage_account.main.primary_access_key
  key_vault_id = azurerm_key_vault.main.id
}

# Azure Storage Account Name
resource "azurerm_key_vault_secret" "storage_account_name" {
  name         = "storage-account-name"
  value        = azurerm_storage_account.main.name
  key_vault_id = azurerm_key_vault.main.id
}

# App Service Plan (Linux)
resource "azurerm_app_service_plan" "web" {
  name                = "tinman-appserviceplan"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Basic"
    size = "B1"
  }

  tags = {
    Environment = "POC"
    Project     = "Tinman"
  }
}

# Web App (Linux)
resource "azurerm_linux_web_app" "web" {
  name                = "tinman-webapp"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  service_plan_id     = azurerm_app_service_plan.web.id

  # Enable managed identity
  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      python_version = "3.11"
    }
    
    # Use proper startup command for FastAPI
    app_command_line = "python -m uvicorn app.main:app --host 0.0.0.0 --port 8000"
  }

  app_settings = {
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "true"
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "PYTHON_VERSION" = "3.11"
    "AZURE_TENANT_ID" = data.azurerm_client_config.current.tenant_id
    "AZURE_SUBSCRIPTION_ID" = data.azurerm_client_config.current.subscription_id
    "AZURE_STORAGE_CONNECTION_STRING" = azurerm_storage_account.main.primary_connection_string
  }

  tags = {
    Environment = "POC"
    Project     = "Tinman"
  }
}

# Note: Key Vault access policy for web app will be added after the managed identity is created
