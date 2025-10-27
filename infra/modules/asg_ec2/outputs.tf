# ASG module outputs

output "asg_name" {
  description = "AutoScalingGroup name (for CW alarms)"
  value       = aws_autoscaling_group.this.name
}
