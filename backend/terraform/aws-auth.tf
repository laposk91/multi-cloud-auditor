data "aws_caller_identity" "current" {}

# A local variable to define all access entries for the EKS cluster.
# This improved version prevents creating duplicate entries.
locals {
  # 1. Define all principals that should have admin access.
  admin_principals = distinct([
    # The user/role running terraform
    data.aws_caller_identity.current.arn,

    # The hardcoded 'devops' user
    "arn:aws:iam::671957687694:user/devops",
  ])

  # 2. Dynamically build the access_entries map from the unique list of principals.
  access_entries = {
    for principal_arn in local.admin_principals :
    # Create a unique key for each entry, e.g., "arn_aws_iam_..._user-devops"
    replace(principal_arn, "/", "-") => {
      principal_arn = principal_arn
      policy_associations = {
        admin_policy = {
          policy_arn   = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = { type = "cluster" }
        }
      }
    }
  }
}

