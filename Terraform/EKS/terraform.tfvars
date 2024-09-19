aws_region             = "us-west-2"
vpc_name               = "eks-vpc"
cluster_name           = "eks-cluster"
k8s_version            = "1.22"
bastion_security_group_id = "<Bastion_SG_ID>"  # Replace with the actual bastion security group ID from the EC2 module output
