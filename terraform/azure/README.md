# Azure Terraform Infrastructure

This folder contains all Terraform code for provisioning Azure resources for the Tinman project.

## Usage

1. Initialize Terraform:
   ```sh
   terraform init
   ```
2. Plan the deployment:
   ```sh
   terraform plan
   ```
3. Apply the deployment:
   ```sh
   terraform apply
   ```

## Structure
- `main.tf`        - Main resources and logic
- `variables.tf`   - Input variables
- `outputs.tf`     - Output values
- `providers.tf`   - Provider configuration

## Notes
- This is for the POC environment only.
- Add secrets and sensitive values via environment variables or a secrets manager, not in code.
