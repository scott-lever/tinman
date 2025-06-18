#!/bin/bash

# Get the publish profile from Azure
echo "Getting Azure Web App publish profile..."
PUBLISH_PROFILE=$(az webapp deployment list-publishing-profiles \
  --name tinman-webapp \
  --resource-group tinman-poc-rg \
  --xml \
  --query "publishData.publishProfile[?publishMethod=='ZipDeploy']" \
  --output tsv)

# Save to file
echo "$PUBLISH_PROFILE" > publish-profile.xml

echo "Publish profile saved to publish-profile.xml"
echo ""
echo "Next steps:"
echo "1. Go to your GitHub repository: https://github.com/YOUR_USERNAME/tinman"
echo "2. Go to Settings → Secrets and variables → Actions"
echo "3. Click 'New repository secret'"
echo "4. Name: AZUREAPPSERVICE_PUBLISHPROFILE"
echo "5. Value: Copy the contents of publish-profile.xml"
echo ""
echo "Or use GitHub CLI if you have it installed:"
echo "gh secret set AZUREAPPSERVICE_PUBLISHPROFILE < publish-profile.xml" 