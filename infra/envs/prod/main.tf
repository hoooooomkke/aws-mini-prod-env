module "vpc" {
  source     = "../../modules/vpc"
  project    = var.project
  env        = var.env
  cidr_block = "10.10.0.0/16"
  azs        = ["ap-northeast-1a", "ap-northeast-1c"]
}

module "alb" {
  source            = "../../modules/alb"
  project           = "mini-prod-hoooo2025"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnets
}

# 鬮ｯ・ｷ髣鯉ｽｨ繝ｻ・ｽ繝ｻ・ｬ鬮ｯ貅ｷ蠎翫・・ｹ隴会ｽｦ繝ｻ・ｽ繝ｻ・ｺ髯具ｽｹ遶擾ｽｽ繝ｻ・ｾ繝ｻ・ｰ: filter 鬩搾ｽｵ繝ｻ・ｺ郢晢ｽｻ繝ｻ・ｯ鬮ｯ・ｷ繝ｻ・ｷ驛｢譎｢・ｽ・ｻ郢晢ｽｻ繝ｻ・ｱ髫ｶ骰玖・・つ郢晢ｽｻ繝ｻ・ｧ鬩幢ｽ｢繝ｻ・ｧ髯ｷ・ｻ騾趣ｽｯ陜鍋ｧ假ｽｫ・ｯ繝ｻ・ｦ髯溷供・ｾ蛟仰陝ｶ譎乗凄髯区ｻゑｽｽ・ｩ郢晢ｽｻ繝ｻ・ｿ郢晢ｽｻ繝ｻ・ｰ
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

module "asg_ec2" {
  source                 = "../../modules/asg_ec2"
  project                = "mini-prod-hoooo2025"
  vpc_id                 = module.vpc.vpc_id
  private_app_subnet_ids = module.vpc.private_app_subnets
  alb_sg_id              = module.alb.alb_sg_id
  target_group_arn       = module.alb.target_group_arn

  ami_id           = data.aws_ami.al2023.id
  instance_type    = "t3.micro"
  desired_capacity = 1
  min_size         = 1
  max_size         = 2

  # 鬩搾ｽｵ繝ｻ・ｺ郢晢ｽｻ繝ｻ・ｾ鬩搾ｽｵ繝ｻ・ｺ髯橸ｽ｢繝ｻ・ｹ驛｢譎｢・ｽ・ｻ IAM 鬩幢ｽ｢繝ｻ・ｧ髯ｷ莉｣繝ｻ繝ｻ・ｽ繝ｻ・ｽ髫ｲ蟶幢ｽ･繝ｻ・ｽ・ｽ髢ｾ・･繝ｻ・ｸ繝ｻ・ｺ驛｢譎｢・ｽ・ｻ00鬩幢ｽ｢繝ｻ・ｧ鬮ｮ蛹ｺ・ｧ・ｫ陟募ｮ｣ﾎ斐・・ｧ驛｢譎｢・ｽ・ｻ  enable_ssm            = false
  instance_profile_name = ""
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
module "s3_logs" {
  source        = "../../modules/s3_logs"
  project       = var.project # => terraform.tfvars 驍ｵ・ｺ繝ｻ・ｮ project 驛｢・ｧ陷代・・ｽ・ｽ繝ｻ・ｿ鬨ｾ蛹・ｽｽ・ｨ("mini-prod")
  env           = var.env     # => terraform.tfvars 驍ｵ・ｺ繝ｻ・ｮ env 驛｢・ｧ陷代・・ｽ・ｽ繝ｻ・ｿ鬨ｾ蛹・ｽｽ・ｨ("prod")
  force_destroy = false
}
module "secrets" { source = "../../modules/secrets" }

module "sns_slack" {
  source            = "../../modules/sns_slack"
  slack_secret_name = module.secrets.slack_webhook_name
}

module "cloudwatch" {
  source         = "../../modules/cloudwatch"
  sns_topic_arn  = module.sns_slack.topic_arn
  alb_arn_suffix = module.alb.alb_arn_suffix          # 髫ｴ魃会ｽｽ・｢髯昴・繝ｻoutput 髯ｷ・ｷ鬮ｦ・ｪ遶頑･｢諠ｺ陋ｹ・ｻ繝ｻ蜀暦ｽｸ・ｺ陝ｶ蜷ｮﾂ・ｻ鬮ｫ陬懈升繝ｻ・ｪ繝ｻ・ｿ髫ｰ・ｨ繝ｻ・ｴ
  tg_arn_suffix  = module.alb.target_group_arn_suffix # 髫ｴ魃会ｽｽ・｢髯昴・繝ｻoutput 髯ｷ・ｷ鬮ｦ・ｪ遶頑･｢諠ｺ陋ｹ・ｻ繝ｻ蜀暦ｽｸ・ｺ陝ｶ蜷ｮﾂ・ｻ鬮ｫ陬懈升繝ｻ・ｪ繝ｻ・ｿ髫ｰ・ｨ繝ｻ・ｴ
  asg_name       = module.asg_ec2.asg_name            # 髫ｴ魃会ｽｽ・｢髯昴・繝ｻoutput 髯ｷ・ｷ鬮ｦ・ｪ遶頑･｢諠ｺ陋ｹ・ｻ繝ｻ蜀暦ｽｸ・ｺ陝ｶ蜷ｮﾂ・ｻ鬮ｫ陬懈升繝ｻ・ｪ繝ｻ・ｿ髫ｰ・ｨ繝ｻ・ｴ
  instance_ids   = []
}

module "audit" {
  source = "../../modules/audit"
  //   logs_bucket = "mini-prod-logs-hoooo2025"
  logs_bucket = "mini-prod-logs-hoooo2025"
}
module "config" {
  source = "../../modules/config"
  //   logs_bucket = "mini-prod-logs-hoooo2025"
}










