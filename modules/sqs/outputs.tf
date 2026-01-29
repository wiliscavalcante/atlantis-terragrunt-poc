output "queue_name" {
  value       = aws_sqs_queue.this.name
  description = "Created queue name."
}

output "queue_arn" {
  value       = aws_sqs_queue.this.arn
  description = "Created queue ARN."
}
