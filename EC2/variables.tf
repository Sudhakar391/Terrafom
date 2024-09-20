# Variables for AWS region, AMI ID, instance type, key pair, and subnet

variable "aws_region" {
  description = "AWS region"
  default     = "us-west-2"                # Default AWS region
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-0acb9a8339ab465bd"    # Replace with a valid AMI ID
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"                 # Default instance type
}

variable "key_name" {
  description = "Key pair name to use for the EC2 instance"
  default     = "windows"                  # Default key pair name (existing key pair)
}

variable "subnet_id" {
  description = "Subnet ID for the EC2 instance"
  default     = "test-subnet"          # Replace with your subnet ID
}
variable "region" {
  description = "AWS region"
}

variable "access_key" {
  description = "AWS access key"
}

variable "secret_key" {
  description = "AWS secret key"
}
