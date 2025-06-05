output "db_instance_id" {
  value       = aws_db_instance.this.id
  description = "RDS instance ID"
}

output "db_endpoint" {
  value       = aws_db_instance.this.endpoint
  description = "RDS instance endpoint"
}

output "db_port" {
  value       = aws_db_instance.this.port
  description = "RDS instance port"
}

output "db_instance_endpoint" {
  value = aws_db_instance.this.address
}

output "security_group_ids" {
  value       = aws_db_instance.this.vpc_security_group_ids
  description = "Security group IDs attached to the RDS instance"
}