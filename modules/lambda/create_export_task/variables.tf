###########
# Function
###########

variable "function_name" {
  type        = string
  default     = "CreateExportTask"
}

variable "handler" {
  type        = string
  default     = "create_export_task.lambda_handler"
}

variable "runtime" {
  type        = string
  default     = "python3.9"
}

variable "description" {
  type        = string
  default     = "Lamba for creating export task"
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds."
  type        = number
  default     = 3
}

variable "role_name" {
  type        = string
  default     = "CreateExportTaskRoleForLambdaFunction"
}

variable "role_description" {
  description = "Description of IAM role to use for Lambda Function"
  type        = string
  default     = "Role for CreateExportTaskRoleForLambdaFunction"
}

variable "bucket_name" {}

variable "object_key" {}

variable "lambda_bucket_name" {}
