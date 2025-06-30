locals {
  aws_region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = local.aws_region
}

#-----------------------------------------------------------
# Data sources to get dynamic information
#-----------------------------------------------------------

# Gets your current public IP address to securely allow access
# to the EKS public endpoint.
data "http" "my_ip" {
  url = "http://ipv4.icanhazip.com"
}

# Gets available availability zones in the region
data "aws_availability_zones" "available" {}


#-----------------------------------------------------------
# ECR Registry
#-----------------------------------------------------------

resource "aws_ecr_repository" "backend" {
  name                 = "multi-cloud-auditor/backend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

#-----------------------------------------------------------
# Outputs for easy access after deployment
#-----------------------------------------------------------

output "cluster_name" {
  description = "EKS cluster name."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint URL."
  value       = module.eks.cluster_endpoint
}

output "configure_kubectl" {
  description = "Run this command to configure kubectl to connect to the cluster."
  value       = "aws eks update-kubeconfig --region ${local.aws_region} --name ${module.eks.cluster_name}"
}

