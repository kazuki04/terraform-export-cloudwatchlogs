###########
# Function
###########

variable "function_name" {
  type        = string
  default     = "DescribeLogGroups"
}

variable "handler" {
  type        = string
  default     = "describe_log_groups.lambda_handler"
}

variable "runtime" {
  type        = string
  default     = "python3.9"
}

variable "description" {
  type        = string
  default     = "Lamba for describe log groups"
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds."
  type        = number
  default     = 3
}

variable "role_name" {
  type        = string
  default     = "DescribeLoggroupsForLambdaFunction"
}

variable "role_description" {
  description = "Description of IAM role to use for Lambda Function"
  type        = string
  default     = "Role for DescribeLogGroupsForLambdaFunction"
}

variable "object_key" {}

variable "lambda_bucket_name" {}
