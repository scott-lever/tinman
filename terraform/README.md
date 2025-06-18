# Terraform Infrastructure

This directory contains all infrastructure-as-code for the Tinman project, organized by provider/service.

## Structure

- `azure/`      - Azure resources (Key Vault, Storage, etc.)
- `supabase/`   - (future) Supabase resources
- `pinecone/`   - (future) Pinecone resources
- `aws/`        - (future) AWS resources
- `modules/`    - (optional) Shared or custom Terraform modules

## Usage
Each subdirectory is self-contained. To deploy a specific provider, `cd` into that folder and run Terraform commands:

```sh
cd terraform/azure
terraform init
terraform plan
terraform apply
```

## Adding a New Provider
1. Create a new subdirectory (e.g., `terraform/gcp/`)
2. Add your Terraform files there
3. Document usage in a `README.md` in that folder

## Best Practices
- Keep provider-specific code isolated
- Use modules for reusable logic
- Store secrets securely (never in code)
