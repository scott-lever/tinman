#!/bin/bash

# Script to update Azure Key Vault secrets with real values
# Usage: ./update_secrets.sh

set -e

KEY_VAULT_NAME="tinman-poc-kv"

echo "🔐 Updating Azure Key Vault secrets..."
echo "Key Vault: $KEY_VAULT_NAME"
echo ""

# Check if Azure CLI is logged in
if ! az account show &> /dev/null; then
    echo "❌ Not logged into Azure CLI. Please run 'az login' first."
    exit 1
fi

# Function to update a secret
update_secret() {
    local secret_name=$1
    local prompt_message=$2
    
    echo "📝 $prompt_message"
    read -s secret_value
    echo ""
    
    if [ -n "$secret_value" ]; then
        echo "🔄 Updating $secret_name..."
        az keyvault secret set --vault-name "$KEY_VAULT_NAME" --name "$secret_name" --value "$secret_value"
        echo "✅ Updated $secret_name"
    else
        echo "⏭️  Skipping $secret_name (empty value)"
    fi
    echo ""
}

# Update each secret
update_secret "supabase-url" "Enter your Supabase URL (e.g., https://your-project.supabase.co):"
update_secret "supabase-anon-key" "Enter your Supabase anonymous key:"
update_secret "supabase-service-role-key" "Enter your Supabase service role key:"

echo "🎉 All secrets updated successfully!"
echo ""
echo "To verify, you can list the secrets:"
echo "az keyvault secret list --vault-name $KEY_VAULT_NAME"
echo ""
echo "To retrieve a secret value:"
echo "az keyvault secret show --vault-name $KEY_VAULT_NAME --name <secret-name>" 