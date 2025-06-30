module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4" # Using a slightly newer, compatible version of the module

  cluster_name    = "auditor-cluster"
  # NOTE: As of now, 1.30 is the latest supported version.
  cluster_version = "1.30"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # --- Configuration for Reachability and Access ---

  # Both public and private endpoints are enabled
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  # IMPORTANT: This now dynamically uses your current IP address from main.tf
  cluster_endpoint_public_access_cidrs = ["${chomp(data.http.my_ip.response_body)}/32"]

  # Use the modern "API" mode for managing access via IAM and Access Entries
  authentication_mode = "API"

  # Grant access to the cluster using the local variable defined in aws-auth.tf
  access_entries = local.access_entries

  # --- Managed Node Group Configuration ---
  eks_managed_node_groups = {
    general_nodes = {
      min_size       = 1
      max_size       = 3
      instance_types = ["t3.small"]
    }
  }

  tags = {
    Project     = "Multi-Cloud Auditor"
    Terraform   = "true"
  }
}

