provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key

}

# Fetch the latest Amazon Linux 2 AMI ID dynamically
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main-vpc"
  }
}

# Create a subnet
resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.region}a"
}

# Create an Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

# Create a route table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "main-route-table"
  }
}
# Create a random string to append to resource names
resource "random_string" "this" {
  length  = 3
  special = false
}

# Associate the route table with the subnet
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

# Create a security group for bastion host
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg-${random_string.this.id}"
  description = "Security group for bastion host"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}


# Create a new key pair
resource "tls_private_key" "bastion" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion-key-${random_string.this.id}"
  public_key = tls_private_key.bastion.public_key_openssh
}

# Create an EC2 instance
resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id] 
  key_name               = aws_key_pair.bastion_key.key_name  # Using the new key pair

  tags = {
    Name = "bastion-${random_string.this.id}"
  }
}

# Save the private key to a file
resource "local_file" "bastion_private_key" {
  content  = tls_private_key.bastion.private_key_pem
  filename = "${path.module}/bastion-key.pem"
}

# Output EC2 instance public IP and key path
output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "key_pair_path" {
  value = local_file.bastion_private_key.filename
}
