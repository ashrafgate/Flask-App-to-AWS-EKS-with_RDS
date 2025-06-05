provider "aws" {
  region = var.aws_region
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = var.tags
}

resource "aws_db_instance" "this" {
  identifier              = var.db_identifier
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  storage_type            = var.storage_type
  username                = var.username
  password                = var.password
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = var.security_group_ids
  skip_final_snapshot     = var.skip_final_snapshot
  multi_az                = var.multi_az
  publicly_accessible     = var.publicly_accessible
  backup_retention_period = var.backup_retention_period
  maintenance_window      = var.maintenance_window
  deletion_protection     = var.deletion_protection
  tags                    = var.tags

  # Optional parameter group (if needed)
  parameter_group_name = var.parameter_group_name != "" ? var.parameter_group_name : null
}

resource "null_resource" "create_products_table" {
  depends_on = [aws_db_instance.this]

  provisioner "local-exec" {
    command = <<EOT
      mysql -h ${aws_db_instance.this.address} \
            -u ${var.username} -p${var.password} \
            -e "CREATE DATABASE IF NOT EXISTS my_product; \
                USE my_product; \
                CREATE TABLE IF NOT EXISTS products ( \
                  id INT AUTO_INCREMENT PRIMARY KEY, \
                  name VARCHAR(255) NOT NULL, \
                  description TEXT, \
                  price DECIMAL(10, 2) NOT NULL, \
                  image_url VARCHAR(255) \
                );"
    EOT
  }
}

