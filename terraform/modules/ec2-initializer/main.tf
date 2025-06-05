resource "aws_instance" "init" {
  ami                         = var.ami_id  # Ubuntu AMI
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet_id # Use private subnet
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = false

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y mysql-client

              mysql -h ${var.rds_endpoint} -u ${var.db_user} -p${var.db_password} -e "
              CREATE DATABASE IF NOT EXISTS my_product;
              USE my_product;
              CREATE TABLE IF NOT EXISTS products (
                id INT AUTO_INCREMENT PRIMARY KEY,
                name VARCHAR(255) NOT NULL,
                description TEXT,
                price DECIMAL(10,2) NOT NULL,
                image_url VARCHAR(255)
              );
              "
              EOF

  tags = {
    Name = "ec2-initializer"
  }
}
