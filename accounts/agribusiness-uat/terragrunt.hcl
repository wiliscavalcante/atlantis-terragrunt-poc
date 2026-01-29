locals {
  organization = "example-org"
  account_name = "agribusiness-uat"
  account_id   = "210987654321"
  environment  = "uat"
  region       = "sa-east-1"
  use_localstack = get_env("USE_LOCALSTACK", "false") == "true"

  backend_bucket = "tfstate-${local.account_name}"
  lock_table     = "tf-lock-${local.account_name}"
}

inputs = {
  tags = {
    Organization = local.organization
    Environment  = local.environment
    Account      = local.account_name
  }
  name_prefix = "${local.organization}-${local.account_name}-${local.environment}"
}

remote_state {
  backend = local.use_localstack ? "local" : "s3"
  config = local.use_localstack ? {
    path = "${path_relative_to_include()}/terraform.tfstate"
  } : {
    bucket         = local.backend_bucket
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.region
    dynamodb_table = local.lock_table
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
  provider "aws" {
    region = "${local.region}"
  ${local.use_localstack ? <<-EOT
    endpoints = {
      s3  = "http://localhost:4566"
      sqs = "http://localhost:4566"
    }
    s3_force_path_style         = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
  EOT
  : ""}
  }
  EOF
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite"
  contents  = local.use_localstack ? <<-EOF
  terraform {
    backend "local" {}
  }
  EOF
  : <<-EOF
  terraform {
    backend "s3" {}
  }
  EOF
}
