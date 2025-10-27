variable "name"            { type = string }
variable "vpc_id"          { type = string }
variable "db_subnet_ids"   { type = list(string) }
variable "app_sg_id"       { type = string }

variable "parameter_family" { type = string }   # "mysql8.0" or "mysql8.4"
variable "engine_version"   { type = string }   # 例: "8.0.39"

variable "instance_class" {
  type    = string
  default = "db.t4g.small"
}

variable "storage_gb" {
  type    = number
  default = 20
}

variable "db_name" {
  type    = string
  default = "appdb"
}

variable "master_username" {
  type    = string
  default = "admin"
}

variable "backup_retention_days" {
  type    = number
  default = 7
}

# ← ここは db_instance なので backup_window が正
variable "backup_window" {
  type    = string
  default = "17:00-18:00"  # UTC, hh24:mi-hh24:mi
}

variable "maintenance_window" {
  type    = string
  default = "sun:18:00-sun:19:00"  # UTC
}

variable "kms_key_id" {
  type    = string
  default = null
}

variable "enhanced_monitoring_role_arn" { type = string }

variable "tags" {
  type    = map(string)
  default = {}
}
