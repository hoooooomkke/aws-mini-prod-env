# === auto-generated outputs for alb module ===
# required by root: module.alb.alb_dns_name / .target_group_arn / .alb_sg_id
# required by cloudwatch: .alb_arn_suffix / .target_group_arn_suffix

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.this.dns_name
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.this.arn
}

output "alb_sg_id" {
  description = "Security Group ID attached to ALB"
  value       = aws_security_group.alb_sg.id
}

output "alb_arn_suffix" {
  description = "ARN suffix of the ALB (for CloudWatch metrics)"
  value       = aws_lb.this.arn_suffix
}

output "target_group_arn_suffix" {
  description = "ARN suffix of the Target Group (for CloudWatch metrics)"
  value       = aws_lb_target_group.this.arn_suffix
}
