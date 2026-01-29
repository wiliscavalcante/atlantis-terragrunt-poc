variable "name_prefix" {
  type        = string
  description = "Common prefix for resource names."
}

variable "domain" {
  type        = string
  description = "Domain grouping (platform, data, app, security, shared)."
}

variable "service" {
  type        = string
  description = "Service or product name."
}

variable "resource" {
  type        = string
  description = "Resource suffix used in naming."
  default     = "sqs"
}

variable "queue_name" {
  type        = string
  description = "Optional explicit queue name to override the standard pattern."
  default     = ""
}

variable "fifo_queue" {
  type        = bool
  description = "Whether the queue is FIFO."
  default     = false
}

variable "content_based_deduplication" {
  type        = bool
  description = "Enable content-based deduplication for FIFO queues."
  default     = false
}

variable "visibility_timeout_seconds" {
  type        = number
  description = "Visibility timeout in seconds."
  default     = 30
}

variable "message_retention_seconds" {
  type        = number
  description = "Retention period in seconds."
  default     = 345600
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the queue."
  default     = {}
}
