variable "role_name"       { type = string }
variable "repo_full_name"  { type = string }          # e.g., hoooooomkke/aws-mini-prod-env
variable "project_prefix"  { type = string }          # e.g., mini-prod-hoooo2025
variable "tfstate_bucket"  { type = string }
variable "tflock_table"    { type = string }
variable "account_id"      { type = string }          # 12 digits
variable "region" {
  type    = string
  default = "ap-northeast-1"
}
