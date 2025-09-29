# Project configuration
variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "quixotic-prism-473023-n8"
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-east1"
}

variable "zone" {
  description = "The GCP zone for zonal cluster"
  type        = string
  default     = "us-east1-c"
}

# Cluster configuration
variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = "cluster-1"
}

variable "cluster_version" {
  description = "The Kubernetes version for the cluster"
  type        = string
  default     = "1.33.4-gke.1134000"
}

variable "release_channel" {
  description = "The release channel for the cluster"
  type        = string
  default     = "REGULAR"
}

# Default node pool configuration
variable "default_pool_name" {
  description = "Name of the default node pool"
  type        = string
  default     = "default-pool"
}

variable "default_machine_type" {
  description = "Machine type for default nodes"
  type        = string
  default     = "e2-standard-2"
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

# GPU node pool configuration
variable "gpu_pool_name" {
  description = "Name of the GPU node pool"
  type        = string
  default     = "gpu"
}

variable "gpu_machine_type" {
  description = "Machine type for GPU nodes"
  type        = string
  default     = "n1-highmem-2"
}

variable "gpu_type" {
  description = "Type of GPU to attach"
  type        = string
  default     = "nvidia-tesla-t4"
}

variable "gpu_count" {
  description = "Number of GPUs per node"
  type        = number
  default     = 1
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
