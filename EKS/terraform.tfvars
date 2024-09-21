# aws_region             = "ap-south-1"
vpc_name               = "eks-vpc"
cluster_name           = "eks-cluster"
k8s_version            = "1.22"
bastion_security_group_id = "bastion-sg-ec2"  # Replace with the actual bastion security group ID from the EC2 module output
