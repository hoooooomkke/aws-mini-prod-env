# ALB module outputs

# ALB DNSなど他の出力が既にあるなら残しつつ、以下を追加
output "alb_arn_suffix" {
  description = "ARN suffix of the ALB (for CW metrics)"
  value       = aws_lb.this.arn_suffix
}

output "target_group_arn_suffix" {
  description = "ARN suffix of the Target Group (for CW metrics)"
  value       = aws_lb_target_group.this.arn_suffix
}
