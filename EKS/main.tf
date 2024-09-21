# main.tf

# Define the AWS provider and specify the region
provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Retrieve available availability zones for the VPC
data "aws_availability_zones" "available" {}

# Create a VPC using the Terraform AWS VPC module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.0"
  name    = var.vpc_name                   # Name for the VPC
  cidr    = var.vpc_cidr                   # CIDR block for the VPC
  azs     = slice(data.aws_availability_zones.available.names, 0, 3)  # Availability zones
  private_subnets = var.private_subnets    # Private subnets for the VPC
  public_subnets  = var.public_subnets     # Public subnets for the VPC
  enable_nat_gateway = true                # Enable NAT gateway for private subnets

  tags = {
    Name = var.vpc_name
  }
}

# Create an EKS cluster using the Terraform AWS EKS module
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.0.0"
  cluster_name    = var.cluster_name       # Name for the EKS cluster
  cluster_version = var.k8s_version        # Kubernetes version for the EKS cluster
  subnets         = module.vpc.public_subnets  # Use public subnets for worker nodes
  vpc_id          = module.vpc.vpc_id      # VPC ID from the VPC module

  node_groups = {
    eks_nodes = {
      desired_capacity = 2                 # Desired number of worker nodes
      max_capacity     = 3                 # Maximum number of worker nodes
      min_capacity     = 1                 # Minimum number of worker nodes
      instance_type    = var.instance_type # EC2 instance type for worker nodes
    }
  }

  tags = {
    Environment = "dev"
  }
}

# Allow the Bastion host to access the EKS cluster
resource "aws_security_group_rule" "allow_bastion_to_eks" {
  type                     = "ingress"          # Ingress rule
  from_port                = 443                # HTTPS port
  to_port                  = 443
  protocol                 = "tcp"              # TCP protocol
  security_group_id        = module.eks.cluster_security_group_id  # EKS cluster security group
  source_security_group_id = var.bastion_security_group_id  # Bastion host security group
}

# Output the EKS cluster endpoint and VPC ID
output "eks_cluster_endpoint" {
  description = "EKS Cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}
