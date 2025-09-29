# Resource Group configuration
variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "llmops-rg"
}

variable "location" {
  description = "The Azure region"
  type        = string
  default     = "East US"
}

# Cluster configuration
variable "cluster_name" {
  description = "The name of the AKS cluster"
  type        = string
  default     = "cluster-1"
}

variable "kubernetes_version" {
  description = "The Kubernetes version for the cluster"
  type        = string
  default     = "1.29"
}

variable "dns_prefix" {
  description = "DNS prefix for the cluster"
  type        = string
  default     = "llmops"
}

# Default node pool configuration
variable "default_pool_name" {
  description = "Name of the default node pool"
  type        = string
  default     = "default"
}

variable "default_vm_size" {
  description = "VM size for default nodes"
  type        = string
  default     = "" # To be filled by user
}

variable "default_disk_size" {
  description = "Disk size for default nodes in GB"
  type        = number
  default     = 100
}

variable "default_initial_nodes" {
  description = "Initial number of nodes in default pool"
  type        = number
  default     = 1
}

variable "default_min_count" {
  description = "Minimum number of nodes in default pool"
  type        = number
  default     = 0
}

variable "default_max_count" {
  description = "Maximum number of nodes in default pool"
  type        = number
  default     = 3
}

# GPU node pool configuration
variable "gpu_pool_name" {
  description = "Name of the GPU node pool"
  type        = string
  default     = "gpu"
}

variable "gpu_vm_size" {
  description = "VM size for GPU nodes"
  type        = string
  default     = "" # To be filled by user
}

variable "gpu_disk_size" {
  description = "Disk size for GPU nodes in GB"
  type        = number
  default     = 100
}

variable "gpu_initial_nodes" {
  description = "Initial number of nodes in GPU pool"
  type        = number
  default     = 1
}

variable "gpu_min_count" {
  description = "Minimum number of nodes in GPU pool"
  type        = number
  default     = 0
}

variable "gpu_max_count" {
  description = "Maximum number of nodes in GPU pool"
  type        = number
  default     = 1
}

# Network configuration
variable "vnet_subnet_id" {
  description = "The ID of the subnet where AKS will be deployed"
  type        = string
  default     = null
}

variable "network_plugin" {
  description = "Network plugin to use for networking (azure or kubenet)"
  type        = string
  default     = "azure"
}

variable "network_policy" {
  description = "Sets up network policy to be used with Azure CNI (calico or azure)"
  type        = string
  default     = "azure"
}
