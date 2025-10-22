# W2 結果レポート

- 日時: 2025-10-22 21:59:50 +09:00
- 環境: prod (ap-northeast-1)

## 達成項目
- ALB 経由で HTTP **200** を確認（lb_status.txt）
- Target Group **healthy** を確認（	arget-health.txt）
- ASG Instance Refresh **Successful**（instance-refresh.json）
- nginx による index 配信（lb_index.html）

## 主要リンク
- ALB: http://mini-prod-hoooo2025-alb-381766404.ap-northeast-1.elb.amazonaws.com/

## 添付ファイル
- alb_status.txt / alb_index.html
- target-health.txt / target-health.json
- instance-refresh.json
- asg-summary.txt
- terraform-outputs.json / terraform-state-list.txt

## メモ
- 改行(CRLF→LF)問題を解消済み。UserDataはLF・UTF-8(BOMなし)で管理。
- SSM/IAM/RDS/監視/Slack/HTTPS(OIDC含む)は **W3以降** で実装。
