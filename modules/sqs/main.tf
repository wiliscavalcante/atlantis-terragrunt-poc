locals {
  queue_name = var.queue_name != "" ? var.queue_name : "${var.name_prefix}-${var.domain}-${var.service}-${var.resource}"
}

resource "aws_sqs_queue" "this" {
  name                       = local.queue_name
  fifo_queue                 = var.fifo_queue
  content_based_deduplication = var.content_based_deduplication
  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds

  tags = var.tags
}
