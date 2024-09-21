# terraform.tfvars

aws_region = "us-west-2"
access_key = "your-access-key"
secret_key = "your-secret-key"
vpc_name = "main-vpc"
vpc_cidr = "10.0.0.0/16"
private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
cluster_name = "my-eks-cluster"
k8s_version = "1.21"
instance_type = "t3.micro"
bastion_security_group_id = "bash-123"  # Replace with actual security group ID
