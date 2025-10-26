# W3 結果レポート（SSM / RDS / 監視 / HTTPS / OIDC）

- 日時: 2025-10-26 16:19:27 +09:00
- 環境: prod (ap-northeast-1)

## 達成
- **SSM**: Session Manager オンライン & ポートフォワード接続手順確立（証跡: ssm-instance-info.json, ec2-iam-instance-profile.json, cwlogs-ssm-session-loggroup.json）
- **RDS**: MySQL 8.0 / 暗号化 / equire_secure_transport=ON（証跡: ds-parameter-require_secure_transport.json, ds-instance-summary.json）
- **安全な接続**: SSMトンネル + ssl-mode=VERIFY_CA で接続検証（操作ログは手元、設計上の根拠はAWS公式）
- **Secrets**: アプリ用資格情報 Secret 作成済（証跡: secret-appdb-credentials.json）
- **監視/通知**: CloudWatch Alarms / SNS（証跡: cloudwatch-alarms.json, sns-*.json）
- **HTTPS/OIDC**: （ドメイン/IdP 依存のため）設定済みなら別セクションへ記述、未なら W4/W5 で継続

## 主要値
- ALB: http://
- RDS endpoint: 
- RDS parameter group: mini-prod-mysql-hoooo2025-pg
- SSM log group: /aws/ssm/session
- App Secret: mini-prod/appdb/credentials

## 添付（docs/w3）
- terraform-outputs.json / terraform-state-list.txt
- ssm-instance-info.json / ec2-iam-instance-profile.json / cwlogs-ssm-session-loggroup.json
- rds-parameter-require_secure_transport.json / rds-instance-summary.json
- cloudwatch-alarms.json / sns-topics.json / sns-subscriptions.json
- alb_status.txt（任意）


## 実行実績（抜粋）

- SSM PortForward 成功 (`AWS-StartPortForwardingSessionToRemoteHost`)
- MySQL 接続: `ssl-mode=VERIFY_CA` / `TLSv1.3` / `TLS_AES_128_GCM_SHA256`
  - `SHOW SESSION STATUS LIKE 'Ssl_version';` → TLSv1.3
  - `SHOW SESSION STATUS LIKE 'Ssl_cipher';` → TLS_AES_128_GCM_SHA256
- `appdb` 作成・`app_user` 作成＆接続・CRUD 確認（`t1` テーブル）
- RDS パラメータ: `require_secure_transport = ON`
- 監視: CloudWatch / SNS 一覧を `docs/w3` に保存
- SSM セッションログ: ロググループ `/aws/ssm/session`（保持は任意）
