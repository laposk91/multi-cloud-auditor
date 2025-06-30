module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "auditor-app-vpc"
  cidr = "10.0.0.0/16"

  # Use the first two available AZs for the subnets
  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  # Using a single NAT gateway is cost-effective for non-production environments
  single_nat_gateway = true
  enable_dns_hostnames = true

  tags = {
    Project     = "Multi-Cloud Auditor"
    Terraform   = "true"
  }
}
