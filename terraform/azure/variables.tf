variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "tinman-poc-rg"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "uksouth"
}

variable "key_vault_name" {
  description = "Name of the Key Vault"
  type        = string
  default     = "tinman-poc-kv-uksouth"
}
