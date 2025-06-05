resource "aws_instance" "init" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = false

  user_data = templatefile("${path.module}/scripts/init-db.sh.tpl", {
    rds_endpoint  = var.rds_endpoint,
    db_user       = var.db_user,
    db_password   = var.db_password
  })

  tags = {
    Name = "ec2-initializer"
  }
}
