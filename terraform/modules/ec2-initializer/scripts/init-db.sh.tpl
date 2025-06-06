#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -x

# Update and install MySQL client
sudo apt update -y
sudo apt install -y mysql-client

# Wait for RDS to be ready (adjust as needed)
sleep 60

mysql -h "${rds_endpoint}" -u "${db_user}" -p"${db_password}" <<EOSQL
CREATE DATABASE IF NOT EXISTS my_product;
USE my_product;
CREATE TABLE IF NOT EXISTS products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  image_url VARCHAR(255)
);
EOSQL

shutdown -h now
