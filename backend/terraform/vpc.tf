data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1" # Using a specific version for consistency

  name = "auditor-app-vpc"
  cidr = "10.0.0.0/16" # The overall IP address range for our private network

  # We create subnets in the first two available Availability Zones.
  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"] # Where our EKS nodes will live
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"] # For public-facing resources like load balancers

  enable_nat_gateway = true # Allows resources in private subnets to reach the internet
  enable_vpn_gateway = false

  tags = {
    Project     = "Multi-Cloud Auditor"
    Terraform   = "true"
  }
}
