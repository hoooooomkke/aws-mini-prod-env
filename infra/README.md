## Progress

- [x] W1: VPC (/16), Subnets (Public×2 / Private-App×2 / Private-DB×2), NAT×1, VPCE (S3/DynamoDB), S3 logs
  - Evidence: \docs/w1/\（state list, vpc/subnets/route-tables/vpc-endpoints, s3-*.json）
- [x] W2: ALB→EC2(nginx), TG healthy, ASG instance refresh
  - Evidence: \docs/w2/\（200応答, target health, instance refresh, terraform outputs）
- [ ] W3: SSM, RDS(MySQL), 監視通知, HTTPS(ACM), OIDC+CI
