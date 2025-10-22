# aws-mini-prod-env

ポートフォリオ用のミニ本番環境を Terraform で構築（リージョン: ap-northeast-1）。

## Overview
- **Backend**: S3 `mini-prod-tfstate-hoooo2025` + DynamoDB `mini-prod-tflock`
- **Network**: VPC /16（Public×2, Private-App×2, Private-DB×2, NAT×1）
- **VPC Endpoints**: S3 / DynamoDB（Gateway）
- **Logs**: S3 `mini-prod-prod-logs`（Versioning / SSE / Lifecycle）

## Repo Layout

infra/
envs/prod/ # backend.hcl / providers.tf / variables.tf / *.tfvars
modules/
vpc/ # VPC, Subnets, RouteTables, NAT, VPCE(Gateway)
s3_logs/ # ログ用S3（暗号化・バージョニング・ライフサイクル）
screenshots/ # 証跡（VPC可視化, S3設定, terraform applyログ）


## Prerequisites
- Terraform **>= 1.6**
- AWS 認証: 環境変数 `AWS_PROFILE=mini`（東京 / ap-northeast-1）
- Backend（S3/DynamoDB）作成済み  
  ※未作成の場合は `backend.hcl` を用意し、S3 バケットと DynamoDB テーブルを先に作成

## How to Apply
```bash
cd infra/envs/prod
terraform init "-backend-config=backend.hcl"
terraform plan
terraform apply


## How to Destroy
cd infra/envs/prod
terraform destroy


## What W1 Creates（検証ポイント）
VPC（/16）と各サブネット（Public×2 / Private-App×2 / Private-DB×2）
RouteTable、NAT Gateway（×1）
Gateway VPC Endpoint（S3 / DynamoDB）
S3（logs）：バージョニング有効、サーバサイド暗号化有効、ライフサイクル（例：30d→IA, 180d→Glacier, 365d Expire）

## Verification Checklist（コンソールまたは CLI）
VPC / Subnets / RouteTables / NAT が想定どおり作成されている
VPC Endpoints（S3/DynamoDB）が Gateway タイプで関連ルートテーブルに関連付け済み
S3（logs）の Versioning 有効、暗号化有効、ライフサイクルが期待どおり

## Cost Notes
NAT Gateway が主な固定費（目安: 約 100 円/日）。検証終了時は destroy 推奨。