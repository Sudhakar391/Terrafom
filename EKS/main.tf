provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Check for existing IAM roles
data "aws_iam_role" "existing_cluster_role" {
  name = "eks-cluster-role"
}

data "aws_iam_role" "existing_worker_node_role" {
  name = "eks-worker-node-role"
}

locals {
  create_cluster_role = length(data.aws_iam_role.existing_cluster_role.arn) == 0 ? 1 : 0
  create_worker_node_role = length(data.aws_iam_role.existing_worker_node_role.arn) == 0 ? 1 : 0
}

# Create a VPC
resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "eks-vpc"
  }
}

# Create public subnets
resource "aws_subnet" "public_subnets" {
  count = 2

  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.eks_vpc.cidr_block, 8, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "eks-public-subnet-${count.index}"
  }
}

# Create private subnets
resource "aws_subnet" "private_subnets" {
  count = 2

  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.eks_vpc.cidr_block, 8, count.index + 2)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "eks-private-subnet-${count.index}"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "eks-igw"
  }
}

# Create a NAT Gateway
resource "aws_eip" "nat" {
  count = 1

  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = 1
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = "eks-nat-gateway"
  }
}

# Create route table for public subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "eks-public-rt"
  }
}

# Associate public subnets with route table
resource "aws_route_table_association" "public_rt_assoc" {
  count          = 2
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# Create route table for private subnets
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[0].id
  }

  tags = {
    Name = "eks-private-rt"
  }
}

# Associate private subnets with route table
resource "aws_route_table_association" "private_rt_assoc" {
  count          = 2
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

# Create IAM role for EKS cluster
resource "aws_iam_role" "eks_cluster_role" {
  count = local.create_cluster_role

  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "*"
        Resource= "*"
      }
    ]
  })
}

# Attach necessary policies to the EKS cluster role
resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  count = local.create_cluster_role

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role[count.index].name
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSVPCResourceController" {
  count = local.create_cluster_role

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role[count.index].name
}

# Create IAM role for EKS worker nodes
resource "aws_iam_role" "eks_worker_node_role" {
  count = local.create_worker_node_role

  name = "eks-worker-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "*"
        Resource= "*"
      }
    ]
  })
}

# Attach necessary policies to the EKS worker node role
resource "aws_iam_role_policy_attachment" "eks_worker_AmazonEKSWorkerNodePolicy" {
  count = local.create_worker_node_role

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_worker_node_role[count.index].name
}

resource "aws_iam_role_policy_attachment" "eks_worker_AmazonEKS_CNI_Policy" {
  count = local.create_worker_node_role

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_worker_node_role[count.index].name
}

resource "aws_iam_role_policy_attachment" "eks_worker_AmazonEC2ContainerRegistryReadOnly" {
  count = local.create_worker_node_role

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_worker_node_role[count.index].name
}

# Create EKS cluster
resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = local.create_cluster_role == 1 ? aws_iam_role.eks_cluster_role[0].arn : data.aws_iam_role.existing_cluster_role.arn

  vpc_config {
    subnet_ids = concat(aws_subnet.public_subnets[*].id, aws_subnet.private_subnets[*].id)
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSVPCResourceController,
  ]
}

# Create EKS node group
resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = local.create_worker_node_role == 1 ? aws_iam_role.eks_worker_node_role[0].arn : data.aws_iam_role.existing_worker_node_role.arn
  subnet_ids      = aws_subnet.private_subnets[*].id

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_size
    min_size     = var.min_size
  }

  instance_types = [var.node_instance_type]

  depends_on = [
    aws_eks_cluster.eks,
    aws_iam_role_policy_attachment.eks_worker_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_worker_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_worker_AmazonEC2ContainerRegistryReadOnly,
  ]
}

data "aws_availability_zones" "available" {}

