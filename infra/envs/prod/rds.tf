resource "aws_iam_role" "rds_em" {
  name               = "rds-monitoring-role"
  assume_role_policy = data.aws_iam_policy_document.rds_em_trust.json
}

data "aws_iam_policy_document" "rds_em_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "rds_em_attach" {
  role       = aws_iam_role.rds_em.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

module "rds" {
  source = "../../modules/rds"
  name   = "mini-prod-mysql-hoooo2025"

  vpc_id        = module.vpc.vpc_id
  db_subnet_ids = module.vpc.private_db_subnets # ← 正しい出力名
  app_sg_id     = module.asg_ec2.app_sg_id

  parameter_family = "mysql8.0" # 8.4なら "mysql8.4"
  engine_version   = "8.0.39"   # 権限があれば後で見直し可

  enhanced_monitoring_role_arn = aws_iam_role.rds_em.arn

  tags = { Project = "aws-mini-prod", Env = "prod", Owner = "hoooo2025" }
}
