# variables.tf

variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "ap-south-1"  # Set a default region or override in terraform.tfvars
}

variable "access_key" {
  description = "The AWS access key to use for API calls."
  type        = string
}

variable "secret_key" {
  description = "The AWS secret key to use for API calls."
  type        = string
  sensitive   = true  # Marks this variable as sensitive to hide it in logs
}

variable "vpc_name" {
  description = "The name of the VPC."
  type        = string
  default     = "main-vpc"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets."
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "my-eks-cluster"
}

variable "k8s_version" {
  description = "The Kubernetes version for the EKS cluster."
  type        = string
  default     = "1.21"  # Set to the desired Kubernetes version
}

variable "instance_type" {
  description = "The EC2 instance type for worker nodes."
  type        = string
  default     = "t3.micro"
}

variable "bastion_security_group_id" {
  description = "Security group ID for the Bastion host."
  type        = string
}
