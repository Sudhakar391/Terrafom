# Output the public IP of the EC2 bastion host
output "bastion_public_ip" {
  description = "Public IP of the EC2 Bastion host"
  value       = aws_instance.bastion.public_ip
}


# Output the name of the generated key pair
# output "key_pair_name" {
#   description = "Key pair name used for the EC2 instance"
#   value       = aws_key_pair.ec2_key_pair.key_name
# }
