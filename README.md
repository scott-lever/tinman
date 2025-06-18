# Tinman Project

A proof-of-concept platform for news/article analysis, built for extensibility and multi-cloud support.

## Structure

- `terraform/`   - Infrastructure-as-code (Azure, Supabase, Pinecone, AWS, etc.)
- `app/`         - (future) Application code (API, web, etc.)
- `scripts/`     - (future) Helper scripts, data loaders, etc.

## Getting Started

1. **Infrastructure:**
   - Start in `terraform/azure/` for Azure resources
   - See `terraform/README.md` for multi-cloud infra approach

2. **Application:**
   - Will be built in `app/` (empty for now)

3. **Scripts:**
   - Place helper scripts in `scripts/` as needed

## Goals
- Clean, reproducible, and extensible infrastructure
- One environment (POC) to start
- Easy to add new cloud providers/services

## Next Steps
- Add your Azure resources in `terraform/azure/`
- Use Terraform to manage all infra
- Expand to Supabase, Pinecone, AWS as needed
