# CI/CD

- PR: `plan` 実行（`-refresh=false`。差分確認のみ）
- main: **apply 一時停止中**（権限調整後に再開予定）

### 再開条件（後日PRで対応）
- OIDCロールへ以下の読み取り/属性取得を付与  
  `iam:Get*`, `cloudtrail:DescribeTrails`, `config:Describe*`,  
  `s3:GetBucketVersioning|GetEncryptionConfiguration|GetBucketPublicAccessBlock|GetLifecycleConfiguration`（logsバケット）
