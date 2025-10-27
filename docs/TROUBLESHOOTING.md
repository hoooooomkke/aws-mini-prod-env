# TROUBLESHOOTING

## Terraform
- Backend認証エラー: `AWS_REGION` 環境変数/`backend.hcl` を確認。
- `Module not installed`: `terraform init`（ローカル検証は `-backend=false` 推奨）
- `AccessDenied` (PR plan): OIDCロールの読み取り権限不足。CI/CD参照。

## インフラ
- ALB 5xx: ネットワーク/ALB側。Targetが`unhealthy`ならASGかUserData確認。
- Target 5xx: アプリ側。SSMでEC2ログを確認（/var/log/cloud-init.log など）。
- RDS接続不可: `ssl-mode=VERIFY_CA`/SG/サブネットを確認。Secretsの認証情報を参照。
