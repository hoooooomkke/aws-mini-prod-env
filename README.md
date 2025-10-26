# 小さな本番環境 on AWS（Terraform）

AWS（ap-northeast-1）に **VPC / ALB+ASG(EC2) / RDS(MySQL) / S3(Logs) / 監視通知 / CI/CD(OIDC)** を最小コストで構築するポートフォリオ。

- **IaC**: Terraform（S3 + DynamoDB Backend）
- **運用**: CloudWatch → SNS → Lambda → Slack
- **監査**: CloudTrail / AWS Config
- **CI/CD**: GitHub Actions（OIDC, PR=plan / main=apply）
- **セキュリティ**: IAM最小権限、IMDSv2必須、SSH禁止（SSM運用）、S3 Public Block

## Quick Start
terraform -chdir=infra/envs/prod init `
  -backend-config="bucket=mini-prod-tfstate-hoooo2025" `
  -backend-config="key=prod/terraform.tfstate" `
  -backend-config="region=ap-northeast-1" `
  -backend-config="dynamodb_table=mini-prod-tflock"
terraform -chdir=infra/envs/prod plan
terraform -chdir=infra/envs/prod apply -auto-approve

## 構成概要
- VPC: /16（Public×2, Private-App×2, Private-DB×2）, NAT×1  
- Web/App: ALB → ASG(EC2 AL2023), IMDSv2必須, SSH禁止（SSMのみ）  
- DB: RDS MySQL（単一AZ, 暗号化, バックアップ+PITR, TLS必須）  
- 監視: CPU/ALB5xx/Target5xx/StatusCheckFailed → Slack通知  
- 監査: CloudTrail（S3: mini-prod-logs-hoooo2025）, AWS Config 基本ルール  
- CI/CD: GitHub Actions（OIDC, 長期アクセスキー不使用）

## リポ構成
infra/
  envs/prod/        # backend.hcl / providers.tf / main.tf / iam_gha.tf など
  modules/          # vpc, alb, asg_ec2, rds, s3_logs, cloudwatch, sns_slack, iam_oidc_github
docs/
  ARCHITECTURE.md / RUNBOOK.md / SECURITY.md / COST.md
  w1/ w2/ w3/ w4/ w5/
screenshots/
  architecture.png / actions-apply.png / slack-alerts.png

## ドキュメント
- docs/ARCHITECTURE.md（構成と設計理由）
- docs/RUNBOOK.md（運用手順）
- docs/SECURITY.md（セキュリティ方針）
- docs/COST.md（コスト）

## 成功基準（SLO）
- `apply`から30分以内に稼働／ALB経由200／ASG自己復旧  
- Slackに4種通知／SSM運用／OIDC apply／destroyで撤収可
