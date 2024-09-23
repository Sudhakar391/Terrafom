
output "eks_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_name" {
  value = module.eks.cluster_id
}

output "eks_cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "kubeconfig" {
  value     = module.eks.kubeconfig
  sensitive = true
}
variable "access_key" {
  description = "AWS access key"
}

variable "secret_key" {
  description = "AWS secret key"
}
variable "bastion_security_group_id" {
  description = "Security group ID for the Bastion host."
  type        = string
}