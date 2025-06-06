output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = module.ecr.repository_url
}

#output "rds_endpoint" {
#  value = module.rds.db_endpoint
#}

output "rds_hostname" {
  value = aws_db_instance.main.address # returns only the hostname (no port)
}
