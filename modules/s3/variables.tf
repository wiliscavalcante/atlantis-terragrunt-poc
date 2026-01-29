variable "bucket_name" {
  type        = string
  description = "S3 bucket name."
}

variable "force_destroy" {
  type        = bool
  description = "Whether to force delete the bucket contents."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the bucket."
  default     = {}
}
