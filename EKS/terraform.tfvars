# terraform.tfvars

vpc_name = "main-vpc"
vpc_cidr = "10.0.0.0/16"
private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
cluster_name = "my-eks-cluster1"
k8s_version = "1.21"
instance_type = "t3.micro"
key_name = "Windows"  # Replace with your actual EC2 key pair name
bastion_security_group_id = "bastion-sg011"  # Replace with actual security group ID
