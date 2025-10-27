variable "sns_topic_arn" {
  type = string
}
variable "alb_arn_suffix" {
  type = string
}
variable "tg_arn_suffix" {
  type = string
}
variable "asg_name" {
  type = string
}
variable "instance_ids" {
  type    = list(string)
  default = []
}

resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "mini-prod-alb-5xx"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  threshold           = 1
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }
  treat_missing_data = "notBreaching"
  alarm_actions      = [var.sns_topic_arn]
}

resource "aws_cloudwatch_metric_alarm" "target_5xx" {
  alarm_name          = "mini-prod-target-5xx"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  threshold           = 1
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  dimensions = {
    TargetGroup = var.tg_arn_suffix
    LoadBalancer = var.alb_arn_suffix
  }
  treat_missing_data = "notBreaching"
  alarm_actions      = [var.sns_topic_arn]
}

resource "aws_cloudwatch_metric_alarm" "status_check" {
  alarm_name          = "mini-prod-ec2-statuscheckfailed"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 1
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Maximum"
  dimensions          = length(var.instance_ids) > 0 ? { InstanceId = var.instance_ids[0] } : null
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_topic_arn]
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "mini-prod-ec2-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  threshold           = 80
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  dimensions          = length(var.instance_ids) > 0 ? { InstanceId = var.instance_ids[0] } : null
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_topic_arn]
}

output "alarm_names" {
  value = [
    aws_cloudwatch_metric_alarm.alb_5xx.alarm_name,
    aws_cloudwatch_metric_alarm.target_5xx.alarm_name,
    aws_cloudwatch_metric_alarm.status_check.alarm_name,
    aws_cloudwatch_metric_alarm.cpu_high.alarm_name,
  ]
}
