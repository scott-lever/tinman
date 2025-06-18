output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.main.name
}

output "openai_account_name" {
  description = "Name of the Azure OpenAI Cognitive Services Account"
  value       = azurerm_cognitive_account.openai.name
}

output "openai_endpoint" {
  description = "Azure OpenAI endpoint URL"
  value       = azurerm_cognitive_account.openai.endpoint
}

output "openai_deployment_name" {
  description = "Name of the GPT-4.1 deployment"
  value       = azurerm_cognitive_deployment.gpt41.name
}

output "openai_model_name" {
  description = "Name of the deployed model"
  value       = azurerm_cognitive_deployment.gpt41.model[0].name
}

output "openai_model_version" {
  description = "Version of the deployed model"
  value       = azurerm_cognitive_deployment.gpt41.model[0].version
}

output "storage_account_name" {
  description = "Name of the Azure Storage Account"
  value       = azurerm_storage_account.main.name
}

output "storage_account_primary_blob_endpoint" {
  description = "Primary blob endpoint URL"
  value       = azurerm_storage_account.main.primary_blob_endpoint
}

output "storage_containers" {
  description = "Names of created storage containers"
  value = {
    raw_uploads = azurerm_storage_container.raw_uploads.name
    processed   = azurerm_storage_container.processed.name
    errors      = azurerm_storage_container.errors.name
    archives    = azurerm_storage_container.archives.name
  }
}
