# Variables for AWS region, VPC, EKS cluster, and bastion security group

variable "aws_region" {
  description = "AWS region"
  default     = "ap-south-1"                # Default AWS region
}

variable "vpc_name" {
  description = "VPC name"
  default     = "eks-vpc"                  # Default VPC name
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"              # Default VPC CIDR block
}

variable "private_subnets" {
  description = "Private subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]  # Private subnets
}

variable "public_subnets" {
  description = "Public subnets"
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]  # Public subnets
}

variable "cluster_name" {
  description = "EKS cluster name"
  default     = "eks-cluster"              # Default EKS cluster name
}

variable "k8s_version" {
  description = "Kubernetes version"
  default     = "1.22"                     # Default Kubernetes version
}

variable "bastion_security_group_id" {
  description = "Security group ID of the Bastion host"
  default     = ""                         # Replace with the bastion security group ID
}
variable "access_key" {
  description = "AWS access key"
}

variable "secret_key" {
  description = "AWS secret key"
}