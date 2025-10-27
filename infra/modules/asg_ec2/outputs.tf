# ASG module outputs

output "asg_name" {
  description = "AutoScalingGroup name (for CW alarms)"
  value       = aws_autoscaling_group.this.name
}

output "app_sg_id" {
  description = "App EC2 Security Group ID (referenced by RDS SG)"
  value       = aws_security_group.app_sg.id
}
