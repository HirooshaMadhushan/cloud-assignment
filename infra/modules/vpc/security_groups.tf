# Load Balancer SG — public internet → 80, 443
resource "aws_security_group" "alb" {
  name        = "cloudmart-alb-sg-${var.common_tags["Environment"]}"
  vpc_id      = aws_vpc.main.id
  description = "ALB: allow HTTP/HTTPS from internet"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP from internet"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS from internet"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound"
  }

  tags = merge(var.common_tags, { Name = "cloudmart-alb-sg-${var.common_tags["Environment"]}" })

  lifecycle {
    create_before_destroy = true
  }
}

# EKS Worker Nodes SG
resource "aws_security_group" "eks_nodes" {
  name        = "cloudmart-eks-nodes-sg-${var.common_tags["Environment"]}"
  vpc_id      = aws_vpc.main.id
  description = "EKS worker nodes: allow ALB to node port range, internal node comms"

  ingress {
    from_port       = 1025
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
    description     = "ALB to NodePort range"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    description = "Node-to-node all traffic"
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
    description     = "SSH from bastion only"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "EKS control plane webhooks"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound (for NAT/VPC endpoints)"
  }

  tags = merge(var.common_tags, { Name = "cloudmart-eks-nodes-sg-${var.common_tags["Environment"]}" })

  lifecycle {
    create_before_destroy = true
  }
}

# RDS (PostgreSQL) SG — only EKS nodes on port 5432
resource "aws_security_group" "rds" {
  name        = "cloudmart-rds-sg-${var.common_tags["Environment"]}"
  vpc_id      = aws_vpc.main.id
  description = "RDS PostgreSQL: only EKS nodes allowed"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_nodes.id]
    description     = "PostgreSQL from EKS nodes only"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound"
  }

  tags = merge(var.common_tags, { Name = "cloudmart-rds-sg-${var.common_tags["Environment"]}" })

  lifecycle {
    create_before_destroy = true
  }
}

# Bastion Host SG — SSH from your office IP only
resource "aws_security_group" "bastion" {
  name        = "cloudmart-bastion-sg-${var.common_tags["Environment"]}"
  vpc_id      = aws_vpc.main.id
  description = "Bastion: SSH from admin CIDR only"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
    description = "SSH from admin IP"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound"
  }

  tags = merge(var.common_tags, { Name = "cloudmart-bastion-sg-${var.common_tags["Environment"]}" })

  lifecycle {
    create_before_destroy = true
  }
}

# VPC Endpoints SG — HTTPS from private subnets
resource "aws_security_group" "vpce" {
  name        = "cloudmart-vpce-sg-${var.common_tags["Environment"]}"
  vpc_id      = aws_vpc.main.id
  description = "VPC Interface Endpoints: HTTPS from private subnets"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.11.0/24", "10.0.12.0/24"]
    description = "HTTPS from private app subnets"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound"
  }

  tags = merge(var.common_tags, { Name = "cloudmart-vpce-sg-${var.common_tags["Environment"]}" })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  name              = "/aws/vpc/cloudmart-flow-logs-${var.common_tags["Environment"]}"
  retention_in_days = 30
  tags              = var.common_tags
}

resource "aws_flow_log" "main" {
  vpc_id          = aws_vpc.main.id
  traffic_type    = "ALL"
  iam_role_arn    = aws_iam_role.flow_logs.arn
  log_destination = aws_cloudwatch_log_group.flow_logs.arn
  tags            = merge(var.common_tags, { Name = "cloudmart-flow-log-${var.common_tags["Environment"]}" })
}

resource "aws_iam_role" "flow_logs" {
  name = "cloudmart-vpc-flow-logs-role-${var.common_tags["Environment"]}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "flow_logs" {
  name = "cloudmart-vpc-flow-logs-policy-${var.common_tags["Environment"]}"
  role = aws_iam_role.flow_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
