# Atlantis + Terragrunt POC

This POC shows a monorepo layout with Terragrunt managing resources across dev/uat/prod.
It is compatible with real AWS and can also run locally using LocalStack.

## What each component does
- Terraform: creates AWS resources.
- Terragrunt: keeps Terraform DRY and consistent across accounts/environments.
- Atlantis: runs `plan`/`apply` for you based on repo changes and approvals.
- LocalStack (optional): fake AWS for local tests.

## Layout
- `accounts/` holds account/env/region specific stacks
- `modules/` holds reusable Terraform modules

## Example structure
```
accounts/
  agribusiness-dev/
    sa-east-1/
      app/
        orders-api/
        portal-web/
        billing-sqs/
      data/
        ml-inference/
      shared/
        s3/
      platform/
        notifier-sqs/
  agribusiness-uat/
    sa-east-1/
      app/
        orders-api/
        portal-web/
      data/
        ml-inference/
      platform/
        notifier-sqs/
  agribusiness-prod/
    sa-east-1/
      app/
        orders-api/
        portal-web/
      data/
        ml-inference/
      platform/
        notifier-sqs/
```

## How it works
- `accounts/terragrunt.hcl` defines org-level defaults
- Each account `terragrunt.hcl` configures remote state and provider
- Each stack `terragrunt.hcl` points to a module and passes inputs

## Naming pattern (example)
Resources use a standard name based on account and environment:
`<org>-<account>-<env>-<domain>-<service>-<resource>`

Example:
`example-org-agribusiness-dev-dev-platform-notifier-sqs`

## Real AWS workflow (recommended)
1) Create the backend per account (S3 bucket + DynamoDB table).
2) Configure each account file with real `account_id`, bucket, and table.
3) Run Terragrunt in the stack folder or use Atlantis to apply.

## Flow to provision a resource in all environments
1) Create or update the module in `modules/` (ex: `modules/s3`).
2) Add a stack folder for each environment and domain:
   - `accounts/agribusiness-dev/sa-east-1/app/<service>/terragrunt.hcl`
   - `accounts/agribusiness-uat/sa-east-1/app/<service>/terragrunt.hcl`
   - `accounts/agribusiness-prod/sa-east-1/app/<service>/terragrunt.hcl`
   - `accounts/agribusiness-dev/sa-east-1/data/<service>/terragrunt.hcl`
   - `accounts/agribusiness-uat/sa-east-1/data/<service>/terragrunt.hcl`
   - `accounts/agribusiness-prod/sa-east-1/data/<service>/terragrunt.hcl`
   - `accounts/agribusiness-dev/sa-east-1/platform/<service>/terragrunt.hcl`
   - `accounts/agribusiness-uat/sa-east-1/platform/<service>/terragrunt.hcl`
   - `accounts/agribusiness-prod/sa-east-1/platform/<service>/terragrunt.hcl`
3) In each stack file, point to the module and set env-specific inputs.
4) Run Terragrunt from each stack directory:
```
cd accounts/agribusiness-dev/sa-east-1/app/orders-api
terragrunt init
terragrunt plan
terragrunt apply
```
Repeat for UAT and PROD.

## Local Atlantis simulation
### LocalStack
Start LocalStack (S3 + SQS):
```
docker compose -f docker-compose.localstack.yml up -d
```

Set env vars for Terraform/Terragrunt:
```
export USE_LOCALSTACK=true
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=sa-east-1
```

1) Start Atlantis in repo root:
```
atlantis server --repo-allowlist=\"*\"
```
2) Run Atlantis commands locally (example for dev):
```
atlantis plan -p agribusiness-dev-platform-notifier-sqs
atlantis apply -p agribusiness-dev-platform-notifier-sqs
```

The repo config is in `atlantis.yaml`.

## Notes
- Update the account ids and bucket names before applying.
- Backend bucket/table should exist or be bootstrapped per account.
