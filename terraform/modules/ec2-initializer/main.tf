resource "aws_instance" "init" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = false

  user_data = <<EOF
#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -x

apt-get update -y
apt-get install -y mysql-client -y

mysql -h ${var.rds_endpoint} -u ${var.db_user} -p${var.db_password} <<SQL
CREATE DATABASE IF NOT EXISTS my_product;
USE my_product;
CREATE TABLE IF NOT EXISTS products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  image_url VARCHAR(255)
);
SQL

shutdown -h now
EOF

  tags = {
    Name = "ec2-initializer"
  }
}
