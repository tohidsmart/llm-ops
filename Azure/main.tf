terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    # Azure Storage Account for state - update with your values
    resource_group_name  = "your-terraform-state-rg"
    storage_account_name = "yourtfstatestorage"
    container_name       = "tfstate"
    key                  = "aks/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

locals {
  cluster_name = var.cluster_name
  location     = var.location

  tags = {
    Environment = "dev"
    Project     = "llmops"
    ManagedBy   = "terraform"
  }
}
