include "account" {
  path = find_in_parent_folders("terragrunt.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/s3"
}

inputs = {
  bucket_name   = "agribusiness-dev-portal-web"
  force_destroy = true
  tags = {
    Product = "portal"
    Team    = "growth"
  }
}
