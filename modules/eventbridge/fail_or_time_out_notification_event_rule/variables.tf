variable "event_rule_name" {
  type    = string
  default = "FailOrTimeOutNotification"
}

variable "role_name" {
  type    = string
  default = "ExcuteStepFunctions"
}

variable "state_machine_arn" {}

variable "sns_topic_arn" {}
