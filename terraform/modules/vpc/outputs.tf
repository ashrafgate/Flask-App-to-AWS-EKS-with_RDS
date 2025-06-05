output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}
output "eks_node_sg_id" {
  description = "Security group ID for the EKS worker nodes"
  value       = aws_security_group.eks_node_sg.id
}
output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}

output "eks_node_sg_id" {
  value = aws_security_group.eks_node_sg.id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}
