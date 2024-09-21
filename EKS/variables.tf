
variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "my-eks-cluster1"
}

variable "node_instance_type" {
  description = "EC2 instance type for the EKS nodes"
  type        = string
  default     = "t3.medium"
}

variable "desired_capacity" {
  description = "The desired number of worker nodes"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "The maximum number of worker nodes"
  type        = number
  default     = 4
}

variable "min_size" {
  description = "The minimum number of worker nodes"
  type        = number
  default     = 2
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


variable "k8s_version" {
  description = "The Kubernetes version for the EKS cluster."
  type        = string
  default     = "1.21"
}

variable "instance_type" {
  description = "The EC2 instance type for worker nodes."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "The name of the EC2 key pair."
  type        = string
}

variable "bastion_security_group_id" {
  description = "Security group ID for the Bastion host."
  type        = string
}

variable "access_key" {
  description = "AWS access key"
}

variable "secret_key" {
  description = "AWS secret key"
}
