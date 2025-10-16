module "s3_logs" {
  source        = "../../modules/s3_logs"
  project       = var.project
  env           = var.env
  force_destroy = false
}

module "vpc" {
  source     = "../../modules/vpc"
  project    = var.project
  env        = var.env
  cidr_block = "10.10.0.0/16"
  azs        = ["ap-northeast-1a", "ap-northeast-1c"]

  create_s3_gateway_vpce       = true
  create_dynamodb_gateway_vpce = true

  logs_bucket_arn = module.s3_logs.bucket_arn
}
