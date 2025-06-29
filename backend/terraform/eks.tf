module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.10.0"

  cluster_name    = "auditor-cluster"
  cluster_version = "1.32"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true  # Enables IAM Roles for Service Accounts

  eks_managed_node_groups = {
    general_nodes = {
      min_size       = 1
      max_size       = 3
      instance_types = ["t3.small"]
    }
  }

  tags = {
    Project   = "Multi-Cloud Auditor"
    Terraform = "true"
  }
}
# create a complete EKS cluster control plane and worker nodes.
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.10.0" # Using a specific version for consistency

  cluster_name    = "auditor-cluster"
  cluster_version = "1.29"

 # This tells the EKS module to build the cluster inside the VPC we defined above.
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # This enables a critical security feature (IAM Roles for Service Accounts)
  # that we will use later to give our application pods permissions.
  cluster_iam_roles_enabled = true

  # This defines the group of EC2 instances that will be our "worker nodes".
  # These are the servers where our application containers will actually run.
  eks_managed_node_groups = {
    general_nodes = {
      min_size     = 1 # Start with one worker node
      max_size     = 3 # Allow scaling up to 3 nodes
      instance_types = ["t3.small"] # A cost-effective instance type for starting out
    }
  }

  tags = {
    Project     = "Multi-Cloud Auditor"
    Terraform   = "true"
  }
}
