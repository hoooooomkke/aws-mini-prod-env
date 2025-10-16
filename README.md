# aws-mini-prod

AWS (ap-northeast-1) を Terraform で構築するポートフォリオ。
- Backend: S3 (mini-prod-tfstate-hoooo2025) + DynamoDB (mini-prod-tflock)
- VPC: /16（Public×2, Private-App×2, Private-DB×2, NAT×1）
- S3 Logs: バージョニング + SSE + ライフサイクル

スクリーンショットは `screenshots/` に格納。
