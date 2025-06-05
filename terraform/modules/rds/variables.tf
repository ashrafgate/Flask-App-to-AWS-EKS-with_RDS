variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "name" {
  type        = string
  description = "Name prefix for resources"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for DB subnet group"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs to assign to the DB instance"
  default     = []
}

variable "db_identifier" {
  type        = string
  description = "The RDS instance identifier"
}

variable "engine" {
  type        = string
  description = "Database engine (e.g., mysql, postgres)"
  default     = "mysql"
}

variable "engine_version" {
  type        = string
  description = "Engine version"
  default     = "8.0"
}

variable "instance_class" {
  type        = string
  description = "Instance class (e.g., db.t3.medium)"
  default     = "db.t3.medium"
}

variable "allocated_storage" {
  type        = number
  description = "Allocated storage in GB"
  default     = 20
}

variable "storage_type" {
  type        = string
  description = "Storage type (e.g., gp2)"
  default     = "gp2"
}

variable "username" {
  type        = string
  description = "Master username for the database"
}

variable "password" {
  type        = string
  description = "Master password for the database"
  sensitive   = true
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Whether to skip final DB snapshot at deletion"
  default     = true
}

variable "multi_az" {
  type        = bool
  description = "Whether to deploy Multi-AZ RDS instance"
  default     = false
}

variable "publicly_accessible" {
  type        = bool
  description = "Whether the DB instance is publicly accessible"
  default     = false
}

variable "backup_retention_period" {
  type        = number
  description = "Number of days to retain backups"
  default     = 7
}

variable "maintenance_window" {
  type        = string
  description = "Preferred maintenance window"
  default     = "sun:23:00-mon:01:30"
}

variable "deletion_protection" {
  type        = bool
  description = "Enable deletion protection"
  default     = false
}

variable "parameter_group_name" {
  type        = string
  description = "Optional DB parameter group name"
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}
