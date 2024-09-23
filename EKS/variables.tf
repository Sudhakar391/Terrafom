variable "region" {
  description = "The AWS region to create the EKS cluster in."
  type        = string
  default     = "ap-south-1"
}

variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "my-eks-cluster"
}

variable "node_instance_type" {
  description = "The EC2 instance type for the EKS worker nodes."
  type        = string
  default     = "t3.medium"
}

variable "desired_capacity" {
  description = "The desired number of worker nodes."
  type        = number
  default     = 2
}

variable "max_size" {
  description = "The maximum number of worker nodes."
  type        = number
  default     = 3
}

variable "min_size" {
  description = "The minimum number of worker nodes."
  type        = number
  default     = 2
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