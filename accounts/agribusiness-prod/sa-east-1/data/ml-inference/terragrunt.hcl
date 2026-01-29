include "account" {
  path = find_in_parent_folders("terragrunt.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/s3"
}

inputs = {
  bucket_name   = "agribusiness-prod-ml-inference"
  force_destroy = true
  tags = {
    Product = "ml-inference"
    Team    = "data"
  }
}
