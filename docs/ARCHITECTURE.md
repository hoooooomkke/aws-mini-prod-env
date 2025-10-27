# Architecture & Rationale

<!-- TODO: put screenshots/architecture.png and uncomment next line -->
<!-- ![architecture](./screenshots/architecture.png) -->

## コンポーネントと役割
- **VPC**: 2AZ, Public/Private-App/Private-DB, NAT×1（コスト最適化）
- **ALB + ASG(EC2)**: IMDSv2必須、SSH禁止（SSM接続運用）、自己復旧
- **RDS(MySQL)**: 単一AZ, 暗号化, 自動バックアップ+PITR, TLS必須
- **S3(Logs)**: CloudTrail/ALB/アプリログ集約、ライフサイクルでIA→Glacier
- **Monitoring**: CloudWatch → SNS → Lambda → Slack（4種通知）
- **Audit**: CloudTrail, AWS Config（restricted-ssh 等の基本ルール）
- **CI/CD**: GitHub Actions OIDC（長期アクセスキー不使用、PR=plan / main=apply）

## 主要な設計判断（Trade-offs）
- **SSH禁止＋SSM運用**：踏み台レス・鍵管理不要・操作監査可能（代わりにSSM前提の運用に統一）
- **RDS単一AZ**：学習/デモ環境としてコスト優先（必要に応じてMulti-AZに拡張可能）
- **NAT×1**：学習環境のため単一構成（片系障害時は影響を許容）
- **Secrets Manager**：資格情報はコード直書きせず、権限分離（最小権限IAM）

## セキュリティ・運用（Non-Functional）
- **最小権限IAM**、IMDSv2必須、S3 Public Block、CloudTrail+Config有効
- **再現性**：Terraform + OIDC CI/CD、状態はS3+DynamoDBでロック
- **運用**：Runbook整備、Slack通知で一次対応、証跡は docs/evidence/ に集約

## 参照
- 詳細手順: [RUNBOOK.md](./RUNBOOK.md)
- セキュリティ方針: [SECURITY.md](./SECURITY.md)
- コスト: [COST.md](./COST.md)
- パイプライン: [CI-CD.md](./CI-CD.md)
