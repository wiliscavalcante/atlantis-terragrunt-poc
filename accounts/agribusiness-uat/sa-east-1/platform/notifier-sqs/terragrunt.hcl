include "account" {
  path = find_in_parent_folders("terragrunt.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/sqs"
}

inputs = {
  domain  = "platform"
  service = "notifier"

  fifo_queue                  = false
  visibility_timeout_seconds  = 45
  message_retention_seconds   = 345600

  tags = {
    Team    = "platform"
    Product = "notifier"
  }
}
