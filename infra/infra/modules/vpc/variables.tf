variable "project"    { type = string }
variable "env"        { type = string }
variable "cidr_block" { type = string }
variable "azs"        { type = list(string) }

variable "logs_bucket_arn" {
  type    = string
  default = ""
}

variable "create_s3_gateway_vpce" {
  type    = bool
  default = true
}

variable "create_dynamodb_gateway_vpce" {
  type    = bool
  default = true
}
