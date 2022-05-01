###########
# Function
###########

variable "function_name" {
  type        = string
  default     = "SendNotificationToSlack"
}

variable "handler" {
  type        = string
  default     = "send_notification_to_slack.lambda_handler"
}

variable "runtime" {
  type        = string
  default     = "python3.9"
}

variable "description" {
  type        = string
  default     = "Lamba for sending notification to Slack"
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds."
  type        = number
  default     = 3
}

variable "role_name" {
  type        = string
  default     = "SendNotificationToSlackRoleForLambdaFunction"
}

variable "role_description" {
  description = "Description of IAM role to use for Lambda Function"
  type        = string
  default     = "Role for SendNotificationToSlackForLambdaFunction"
}

variable "object_key" {}

variable "lambda_bucket_name" {}
