# Cluster outputs
output "cluster_name" {
  description = "The name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.name
}

output "cluster_endpoint" {
  description = "The Kubernetes API server endpoint"
  value       = azurerm_kubernetes_cluster.main.kube_config[0].host
  sensitive   = true
}

output "cluster_location" {
  description = "The location of the cluster"
  value       = azurerm_kubernetes_cluster.main.location
}

output "cluster_ca_certificate" {
  description = "The cluster CA certificate"
  value       = base64decode(azurerm_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate)
  sensitive   = true
}

output "kubernetes_version" {
  description = "The Kubernetes version of the cluster"
  value       = azurerm_kubernetes_cluster.main.kubernetes_version
}

# Resource Group outputs
output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "The location of the resource group"
  value       = azurerm_resource_group.main.location
}

# Node pool outputs
output "default_node_pool_name" {
  description = "The name of the default node pool"
  value       = azurerm_kubernetes_cluster.main.default_node_pool[0].name
}

output "gpu_node_pool_name" {
  description = "The name of the GPU node pool"
  value       = var.gpu_vm_size != "" ? azurerm_kubernetes_cluster_node_pool.gpu[0].name : null
}

# Network outputs
output "network_plugin" {
  description = "The network plugin used"
  value       = azurerm_kubernetes_cluster.main.network_profile[0].network_plugin
}

output "network_policy" {
  description = "The network policy used"
  value       = azurerm_kubernetes_cluster.main.network_profile[0].network_policy
}

# Identity outputs
output "cluster_identity" {
  description = "The cluster's managed identity"
  value       = azurerm_kubernetes_cluster.main.identity[0].principal_id
}

# Monitoring outputs
output "log_analytics_workspace_id" {
  description = "The Log Analytics workspace ID"
  value       = azurerm_log_analytics_workspace.main.id
}

# Connection commands
output "kubectl_connection_command" {
  description = "Command to connect kubectl to the cluster"
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.main.name} --name ${azurerm_kubernetes_cluster.main.name}"
}

output "kubeconfig" {
  description = "Raw kubeconfig for the cluster"
  value       = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive   = true
}