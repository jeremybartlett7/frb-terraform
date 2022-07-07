output "endpoint" {
  description = "The connection endpoint."
  value       = aws_db_instance.this.endpoint
}

output "arn" {
  description = "The ARN of the RDS instance."
  value       = aws_db_instance.this.arn
}
