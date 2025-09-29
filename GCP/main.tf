terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }

  backend "gcs" {
    # GCS bucket for state - update with your bucket name
    bucket = "your-terraform-state-bucket"
    prefix = "gke/terraform.tfstate"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

locals {
  cluster_name = var.cluster_name
  region       = var.region

  tags = {
    Environment = "dev"
    Project     = "llmops"
    ManagedBy   = "terraform"
  }
}
