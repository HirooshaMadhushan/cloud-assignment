resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

resource "aws_iam_role" "github_actions" {
  name = "cloudmart-github-actions-role-${var.common_tags["Environment"]}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Federated = aws_iam_openid_connect_provider.github.arn }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:HirooshaMadhushan/cloud-assignment:*"
        }
      }
    }]
  })
}

# Attach policies: ECR push, EKS describe, limited deploy
resource "aws_iam_role_policy_attachment" "github_ecr" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

# EKS cluster access for GitHub Actions
resource "aws_iam_role_policy" "github_eks" {
  name = "cloudmart-github-actions-eks-policy-${var.common_tags["Environment"]}"
  role = aws_iam_role.github_actions.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:AccessKubernetesApi"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "sts:AssumeRoleWithWebIdentity"
        ]
        Resource = "*"
      }
    ]
  })
}

# Allow kubectl and helm operations
resource "aws_iam_role_policy" "github_k8s_operations" {
  name = "cloudmart-github-actions-k8s-policy-${var.common_tags["Environment"]}"
  role = aws_iam_role.github_actions.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeInstances"
        ]
        Resource = "*"
      }
    ]
  })
}

# Map GitHub Actions IAM role to EKS Access Entry
resource "aws_eks_access_entry" "github_actions" {
  cluster_name      = aws_eks_cluster.main.name
  principal_arn     = aws_iam_role.github_actions.arn
  kubernetes_groups = ["system:masters"]
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "github_actions" {
  cluster_name  = aws_eks_cluster.main.name
  policy_arn    = "arn:aws:iam::aws:policy/AmazonEKSClusterAdminPolicy"
  principal_arn = aws_iam_role.github_actions.arn

  access_scope {
    type = "cluster"
  }
}
