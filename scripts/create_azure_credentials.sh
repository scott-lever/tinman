#!/bin/bash

echo "Creating Azure credentials JSON for GitHub Actions..."

# Get the credentials from Key Vault
CLIENT_ID=$(az keyvault secret show --vault-name tinman-poc-kv-uksouth --name github-actions-client-id --query value -o tsv)
CLIENT_SECRET=$(az keyvault secret show --vault-name tinman-poc-kv-uksouth --name github-actions-client-secret --query value -o tsv)
TENANT_ID=$(az keyvault secret show --vault-name tinman-poc-kv-uksouth --name github-actions-tenant-id --query value -o tsv)
SUBSCRIPTION_ID=$(az keyvault secret show --vault-name tinman-poc-kv-uksouth --name github-actions-subscription-id --query value -o tsv)

# Create the full credentials JSON
AZURE_CREDENTIALS='{
  "clientId": "'$CLIENT_ID'",
  "clientSecret": "'$CLIENT_SECRET'",
  "subscriptionId": "'$SUBSCRIPTION_ID'",
  "tenantId": "'$TENANT_ID'",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com/",
  "managementEndpointUrl": "https://management.core.windows.net/"
}'

# Save to file
echo "$AZURE_CREDENTIALS" > azure-credentials.json

# Set GitHub secret
gh secret set AZURE_CREDENTIALS < azure-credentials.json

echo "Azure credentials JSON created and set as GitHub secret!"
echo "You can now delete azure-credentials.json for security" 