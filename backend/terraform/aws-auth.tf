data "aws_caller_identity" "current" {}

# A local variable to define all access entries for the EKS cluster.
# This keeps the access logic separate from the cluster definition.
locals {
  access_entries = {
    # Entry for the IAM User/Role running Terraform. This is CRITICAL.
    terraform_runner_admin = {
      principal_arn = data.aws_caller_identity.current.arn
      policy_associations = {
        admin_policy = {
          policy_arn   = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = { type = "cluster" }
        }
      }
    },
    # Entry for your 'devops' user.
    devops_user_admin = {
      principal_arn = "arn:aws:iam::671957687694:user/devops"
      policy_associations = {
        admin_policy = {
          policy_arn   = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = { type = "cluster" }
        }
      }
    }
  }
}
