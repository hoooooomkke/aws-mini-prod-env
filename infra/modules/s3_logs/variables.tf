variable "project" { type = string }
variable "env"     { type = string }

variable "force_destroy" {
  type    = bool
  default = false
}
