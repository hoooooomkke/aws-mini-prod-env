terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

# GitHub OIDC provider
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# Role assumed by GitHub Actions (repo-scoped)
resource "aws_iam_role" "gha_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": { "Federated": "${aws_iam_openid_connect_provider.github.arn}" },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": { "token.actions.githubusercontent.com:aud": "sts.amazonaws.com" },
        "StringLike":   { "token.actions.githubusercontent.com:sub": "repo:${var.repo_full_name}:*" }
      }
    }]
  })
}

# --- Least privilege for TF backend (S3 + DynamoDB) ---
data "aws_s3_bucket" "state" { bucket = var.tfstate_bucket }

resource "aws_iam_policy" "backend_min" {
  name        = "${var.project_prefix}-gha-backend"
  description = "Access to Terraform backend (state+lock)"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "S3StateRW",
        "Effect": "Allow",
        "Action": ["s3:ListBucket","s3:GetObject","s3:PutObject","s3:DeleteObject"],
        "Resource": [
          "${data.aws_s3_bucket.state.arn}",
          "${data.aws_s3_bucket.state.arn}/*"
        ]
      },
      {
        "Sid": "DynamoDBLockRW",
        "Effect": "Allow",
        "Action": ["dynamodb:DescribeTable","dynamodb:GetItem","dynamodb:PutItem","dynamodb:DeleteItem","dynamodb:UpdateItem"],
        "Resource": "arn:aws:dynamodb:${var.region}:${var.account_id}:table/${var.tflock_table}"
      }
    ]
  })
}

# --- Scoped ops for this project (初期は広め→後で締める) ---
resource "aws_iam_policy" "project_ops" {
  name        = "${var.project_prefix}-gha-project-ops"
  description = "Ops for mini-prod (tighten later)"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "CrudCommon",
        "Effect": "Allow",
        "Action": [
          "ec2:*","elasticloadbalancing:*","autoscaling:*","rds:*",
          "logs:*","cloudwatch:*","sns:*","ssm:*","secretsmanager:*","acm:*"
        ],
        "Resource": "*"
      },
      {
        "Sid": "IamReadPassRole",
        "Effect": "Allow",
        "Action": ["iam:GetRole","iam:List*","iam:PassRole"],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_backend" {
  role       = aws_iam_role.gha_role.name
  policy_arn = aws_iam_policy.backend_min.arn
}

resource "aws_iam_role_policy_attachment" "attach_ops" {
  role       = aws_iam_role.gha_role.name
  policy_arn = aws_iam_policy.project_ops.arn
}

output "gha_role_arn" {
  description = "ARN of GitHub Actions OIDC role"
  value       = aws_iam_role.gha_role.arn
}
