provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source              = "./modules/vpc"
  aws_region          = var.aws_region
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs= var.private_subnet_cidrs
  cluster_name        = var.cluster_name
  name                = var.cluster_name
}

module "rds" {
  source             = "./modules/rds"
  aws_region         = var.aws_region
  name               = var.cluster_name
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.vpc.eks_node_sg_id]  # or create separate SG for RDS
  db_identifier      = "${var.cluster_name}-db"
  username           = var.db_username
  password           = var.db_password
  tags               = var.tags

  # Optional overrides if you want
  allocated_storage = 20
  instance_class    = "db.t3.medium"
  engine            = "mysql"
  engine_version    = "8.0"
}


resource "aws_key_pair" "eks_key" {
  key_name   = "${var.cluster_name}-key"
  public_key = file(var.public_key_path)

  tags = {
    Name = "${var.cluster_name}-key"
  }
}

module "eks" {
  source             = "./modules/eks"
  aws_region         = var.aws_region
  cluster_name       = var.cluster_name
  private_subnet_ids  = module.vpc.private_subnet_ids
  desired_capacity   = var.desired_capacity
  eks_node_sg_id     = module.vpc.eks_node_sg_id
  max_size           = var.max_size
  min_size           = var.min_size
  instance_types     = var.instance_types
  ami_type           = var.ami_type
  tags               = var.tags
  ssh_key_name  = aws_key_pair.eks_key.key_name
}


module "ecr" {
  source          = "./modules/ecr"
  repository_name = var.repository_name
}






