terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    # S3 bucket for state - to be filled by user
    bucket = "your-s3-bucket"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.region
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
