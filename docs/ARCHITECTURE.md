# ARCHITECTURE

## 目的
「実運用に耐える最小構成」をIaCで再現。コスト最小化と運用容易性を両立する。

## 全体図
- VPC (/16) with 2AZ
- Public Subnet: ALB
- Private-App Subnet: EC2 (ASG)
- Private-DB Subnet: RDS (MySQL)
- NAT x1, VPC Endpoint: S3/DynamoDB (Gateway)
- S3 (logs): CloudTrail/アプリ/ALBアクセスログ集約
- CloudWatch → SNS → Lambda → Slack
- GitHub Actions → OIDC → Terraform（S3/DynamoDB Backend）

> `screenshots/architecture.png` 参照

## 設計の要点
- 2AZ構成、NAT×1、VPCE(Gateway)
- IMDSv2必須 / SSH禁止 / SSM運用
- ALB→EC2:80のみ許可
- RDS: 暗号化 + TLS必須
- CloudWatch/SNS/Lambda/Slack通知
- CloudTrail/AWS Config 監査
- GitHub Actions(OIDC) CI/CD

## 将来拡張
- WAF
- CloudFront
- ECS(Fargate)
