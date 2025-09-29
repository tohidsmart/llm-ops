# Cluster outputs
output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = module.gke.name
}

output "cluster_endpoint" {
  description = "The IP address of the cluster master"
  value       = module.gke.endpoint
  sensitive   = true
}

output "cluster_location" {
  description = "The location (zone) of the cluster"
  value       = module.gke.location
}

output "cluster_ca_certificate" {
  description = "The cluster CA certificate"
  value       = module.gke.ca_certificate
  sensitive   = true
}

output "kubernetes_version" {
  description = "The Kubernetes version of the cluster"
  value       = module.gke.master_version
}

# Network outputs
output "network" {
  description = "The VPC network name"
  value       = "default"
}

output "subnetwork" {
  description = "The subnetwork name"
  value       = "default"
}

# Node pool outputs
output "node_pools" {
  description = "List of node pools"
  value       = module.gke.node_pools_names
}

# Connection command
output "kubectl_connection_command" {
  description = "Command to connect kubectl to the cluster"
  value       = "gcloud container clusters get-credentials ${module.gke.name} --zone=${var.zone} --project=${var.project_id}"
}