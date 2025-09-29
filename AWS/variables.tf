variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "llmops-cluster"
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.31"  # Using stable version instead of 1.33
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "system_instance_type" {
  description = "Instance type for system nodes"
  type        = string
  default     = "t3.medium"
}

variable "gpu_instance_type" {
  description = "Instance type for GPU nodes"
  type        = string
  default     = "g4dn.xlarge"
}