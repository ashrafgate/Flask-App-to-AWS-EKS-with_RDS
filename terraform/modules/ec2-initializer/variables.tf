variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 will be launched (preferably private)"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID that allows egress to RDS"
  type        = string
}

variable "rds_endpoint" {
  description = "RDS endpoint to connect to"
  type        = string
}

variable "db_user" {
  description = "RDS master username"
  type        = string
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}
