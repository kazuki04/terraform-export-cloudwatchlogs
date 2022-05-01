################
# Step Function
################

variable "name" {
  description = "The name of the Step Function"
  type        = string
  default     = "ExportLogsToS3"
}

variable "type" {
  description = "Determines whether a Standard or Express state machine is created. The default is STANDARD. Valid Values: STANDARD | EXPRESS"
  type        = string
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "EXPRESS"], upper(var.type))
    error_message = "Step Function type must be one of the following (STANDARD | EXPRESS)."
  }
}

#################
# CloudWatch Logs
#################

variable "logging_configuration" {
  description = "Defines what execution history events are logged and where they are logged"
  type        = map(string)
  default     = {}
}

###########
# IAM Role
###########

variable "role_description" {
  description = "Description of IAM role to use for Step Function"
  type        = string
  default     = null
}

variable "describe_log_groups_lambda_arn" {}

variable "create_export_task_lambda_arn" {}

variable "describe_export_task_lambda_arn" {}

variable "send_notification_to_slack_lambda_arn" {}
