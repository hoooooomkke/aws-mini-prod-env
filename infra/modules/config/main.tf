data "aws_caller_identity" "current" {}

resource "aws_config_configuration_recorder" "recorder" {
  name = "default"
  # サービスリンクドロールを使用
  role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig"

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "channel" {
  name           = "default"
  s3_bucket_name = "mini-prod-logs-hoooo2025"
  s3_key_prefix  = "config" # 末尾スラッシュ無し
}

resource "aws_config_configuration_recorder_status" "recorder" {
  name       = aws_config_configuration_recorder.recorder.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.channel]
}
