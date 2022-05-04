variable "profile" {
  type    = string
  default = "default"
}

variable "aws_region" {
  type    = string
  default = "ap-northeast-1"
}

variable "email_address" {
  type    = string
  default = "sample@gmail.com"
}

variable "target_log_group_prefix" {
  type    = string
  default = "/aws/lambda/test"
}
