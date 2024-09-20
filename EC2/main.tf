# Define the AWS provider and specify the region
provider "aws" {
  region                  = var.region
  access_key              = var.access_key
  secret_key              = var.secret_key
}




# Define a security group to allow SSH access to the bastion host
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg-tarak1"               # Name of the security group
  description = "Allow SSH access"         # Description for the security group

  # Inbound rule to allow SSH access from anywhere
  ingress {
    from_port   = 22                       # Start port for SSH
    to_port     = 22                       # End port for SSH
    protocol    = "tcp"                    # Protocol used for SSH
    cidr_blocks = ["0.0.0.0/0"]            # Allow access from all IPs
  }

  # Outbound rule to allow all traffic from the bastion host
  egress {
    from_port   = 0                        # Allow all outbound traffic
    to_port     = 0
    protocol    = "-1"                     # All protocols
    cidr_blocks = ["0.0.0.0/0"]            # To any IP address
  }
}
# Define the EC2 instance resource to act as a bastion host
resource "aws_instance" "bastion" {
  ami           = var.ami_id               # Specify the AMI ID for the EC2 instance
  instance_type = var.instance_type        # Specify the instance type

  key_name = var.key_name                  # Use the existing key pair provided in the variable

  vpc_security_group_ids = [aws_security_group.bastion_sg.id]  # Attach security group
  subnet_id              = var.subnet_id                       # Specify the subnet ID

  tags = {
    Name = "EKS-Bastion-Host"  # Tag the instance for easy identification
  }
}
# Output the public IP of the bastion host for SSH access
output "bastion_ip" {
  value = aws_instance.bastion.public_ip   # Outputs the EC2 instance public IP
}

# Output the name of the existing key pair being used
output "key_pair_name" {
  value = aws_instance.bastion.key_name    # Outputs the key pair name used in the EC2 instance
}
