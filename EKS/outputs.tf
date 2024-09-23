
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
}output "eks_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

