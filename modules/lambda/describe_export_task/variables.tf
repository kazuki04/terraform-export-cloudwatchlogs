###########
# Function
###########

variable "function_name" {
  type        = string
  default     = "DescribeExportTask"
}

variable "handler" {
  type        = string
  default     = "describe_export_task.lambda_handler"
}

variable "runtime" {
  type        = string
  default     = "python3.9"
}

variable "description" {
  type        = string
  default     = "Lamba for describe export task"
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds."
  type        = number
  default     = 3
}

variable "role_name" {
  type        = string
  default     = "DescribeExportTaskRoleForLambdaFunction"
}

variable "role_description" {
  description = "Description of IAM role to use for Lambda Function"
  type        = string
  default     = "Role for DescribeExportTaskRoleForLambdaFunction"
}

variable "object_key" {}

variable "lambda_bucket_name" {}
