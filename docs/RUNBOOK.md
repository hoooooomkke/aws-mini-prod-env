# RUNBOOK

## 1. 日常運用
- `terraform output alb_dns_name` → ブラウザで200確認
- Slack通知: CPU/ALB5xx/Target5xx/StatusCheckFailed
- PRでplan, mainマージでapply（CI/CD運用）

## 2. 障害対応
### EC2異常
1. EC2停止→ASG自動復旧確認  
2. SSM接続→`systemctl status`確認  
3. CloudWatchメトリクス確認

### 高負荷
- 一時的: 様子見  
- 継続: ASGスケールOut or インスタンスタイプ変更

### RDS接続異常
- TLS設定(`ssl-mode=VERIFY_CA`)確認  
- SSMポートフォワードで疎通確認

### ALB5xx / Target5xx
- ALB5xx: ネットワーク側  
- Target5xx: アプリ側

## 3. 変更管理
- PRでplan → mainマージでapply  
- 緊急時: `git revert` → apply

## 4. 破棄
```bash
terraform -chdir=infra/envs/prod destroy
