terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # This backend block is commented out for now.
  # For solo development, we will start with local state.
  # We will enable this later when team collaboration is needed.
  # backend "s3" {
  #   bucket         = "your-unique-terraform-state-bucket"
  #   key            = "multi-cloud-auditor/terraform.tfstate"
  #   region         = "us-east-1"
  # }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_ecr_repository" "backend" {
  name                 = "multi-cloud-auditor/backend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
