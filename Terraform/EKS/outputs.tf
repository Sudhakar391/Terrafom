# Outputs for the EKS cluster

# Output the name of the EKS cluster
output "cluster_name" {
  description = "EKS Cluster Name"
  value       = module.eks.cluster_name
}

# Output the kubeconfig file content to access the EKS cluster
output "kubeconfig" {
  description = "Kubeconfig for the EKS cluster"
  value       = module.eks.kubeconfig
}

# Output the endpoint of the EKS cluster
output "cluster_endpoint" {
  description = "Cluster endpoint"
  value       = module.eks.cluster_endpoint
}
