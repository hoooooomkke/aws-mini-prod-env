# W1 結果レポート

- 環境: prod (ap-northeast-1)
- VPC: tag Name=mini-prod-prod（/16、Public×2 / Private-App×2 / Private-DB×2）
- NAT GW: 1
- VPC Endpoints: S3, DynamoDB（Gateway）
- S3 logs: \$bucket\（Versioning / SSE-AES256 / Lifecycle）

## 添付
- terraform-state-list.txt
- vpc.json / subnets.json / route-tables.json / vpc-endpoints.json
- s3-versioning.json / s3-encryption.json / s3-public-access-block.json / s3-lifecycle.json

## メモ
- NAT GWが主な固定費（~¥100/日目安）。検証終了時は \	erraform destroy\ 推奨。
