output "initializer_instance_id" {
  description = "ID of the EC2 initializer instance"
  value       = aws_instance.init.id
}
