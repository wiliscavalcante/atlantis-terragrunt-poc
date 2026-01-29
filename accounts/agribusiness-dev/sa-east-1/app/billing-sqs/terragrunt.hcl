include "account" {
  path = find_in_parent_folders("terragrunt.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/sqs"
}

inputs = {
  domain  = "app"
  service = "billing"

  fifo_queue                 = false
  visibility_timeout_seconds = 30
  message_retention_seconds  = 345600

  tags = {
    Team    = "payments"
    Product = "billing"
  }
}
