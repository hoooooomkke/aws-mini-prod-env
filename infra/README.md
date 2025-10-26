## Progress

- [x] W1: VPC (/16), Subnets (Public×2 / Private-App×2 / Private-DB×2), NAT×1, VPCE (S3/DynamoDB), S3 logs
  - Evidence: \docs/w1/\（state list, vpc/subnets/route-tables/vpc-endpoints, s3-*.json）
- [x] W2: ALB→EC2(nginx), TG healthy, ASG instance refresh
  - Evidence: \docs/w2/\（200応答, target health, instance refresh, terraform outputs）
- [ ] W3: SSM, RDS(MySQL), 監視通知, HTTPS(ACM), OIDC+CI

# W2 達成状況

- 日時: 2025-10-26 16:01:45 +09:00
- 環境: prod (ap-northeast-1)

## 200応答（ALB）
- URL: http:///
- 詳細: docs/w2/alb_status.txt, alb_index.html

## Target Group ヘルス
- docs/w2/target-health.txt, target-health.json

## ASG Instance Refresh
- docs/w2/instance-refresh.json（結果: Successful を確認）

## 補足
- ASG 構成: docs/w2/asg-summary.txt
- Terraform出力/状態: docs/w2/terraform-outputs.json, terraform-state-list.txt
