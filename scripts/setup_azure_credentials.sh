#!/bin/bash

echo "Creating Azure service principal for GitHub Actions..."

# Create service principal and get credentials
AZURE_CREDENTIALS=$(az ad sp create-for-rbac \
  --name "tinman-github-actions-$(date +%s)" \
  --role contributor \
  --scopes /subscriptions/0b1d27da-75a4-40b6-8e38-9fa17d4f7dea/resourceGroups/tinman-poc-rg \
  --sdk-auth)

# Save to file
echo "$AZURE_CREDENTIALS" > azure-credentials.json

# Set GitHub secret
gh secret set AZURE_CREDENTIALS < azure-credentials.json

echo "Azure credentials set up successfully!"
echo "You can now delete azure-credentials.json for security" 