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

# 公式準拠: filter は各属性を改行で記述
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

  # まずは IAM を作らず200を取る
  enable_ssm            = false
  instance_profile_name = ""
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
module "s3_logs" {
  source        = "../../modules/s3_logs"
  project       = var.project   # => terraform.tfvars �� project ���g�p("mini-prod")
  env           = var.env       # => terraform.tfvars �� env ���g�p("prod")
  force_destroy = false
}
