variable "logs_bucket" {
  type = string
}

resource "aws_cloudtrail" "main" {
  name                          = "mini-prod-trail"
  s3_bucket_name                = var.logs_bucket
  s3_key_prefix                 = "cloudtrail/"
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
}

output "trail_name" {
  value = aws_cloudtrail.main.name
}
