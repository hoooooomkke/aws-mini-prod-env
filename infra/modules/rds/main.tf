terraform {
  required_providers { aws = { source = "hashicorp/aws" } }
}

resource "aws_db_subnet_group" "this" {
  name       = var.name
  subnet_ids = var.db_subnet_ids
  tags       = var.tags
}

resource "aws_security_group" "rds" {
  name        = "${var.name}-sg"
  description = "RDS MySQL SG"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.app_sg_id] # App層SGのみ許可
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_db_parameter_group" "mysql" {
  name        = "${var.name}-pg"
  family      = var.parameter_family
  description = "MySQL param group"

  parameter {
    name  = "require_secure_transport"
    value = "ON"
  }
  parameter {
    name  = "slow_query_log"
    value = "1"
  }
  parameter {
    name  = "long_query_time"
    value = "1"
  }
  parameter {
    name  = "general_log"
    value = "0"
  }

  tags = var.tags
}

resource "aws_db_instance" "this" {
  identifier                  = var.name
  engine                      = "mysql"
  engine_version              = var.engine_version
  instance_class              = var.instance_class
  db_name                     = var.db_name
  username                    = var.master_username
  manage_master_user_password = true

  allocated_storage           = var.storage_gb
  storage_type                = "gp3"
  storage_encrypted           = true
  kms_key_id                  = var.kms_key_id

  db_subnet_group_name        = aws_db_subnet_group.this.name
  vpc_security_group_ids      = [aws_security_group.rds.id]
  publicly_accessible         = false
  multi_az                    = false
  deletion_protection         = true
  copy_tags_to_snapshot       = true

  backup_retention_period     = var.backup_retention_days
  backup_window               = var.backup_window        # ← これが正
  maintenance_window          = var.maintenance_window
  auto_minor_version_upgrade  = true

  monitoring_interval         = 60
  monitoring_role_arn         = var.enhanced_monitoring_role_arn
  enabled_cloudwatch_logs_exports = ["error","general","slowquery"]
  performance_insights_enabled = false

  parameter_group_name        = aws_db_parameter_group.mysql.name

  tags = var.tags
}

