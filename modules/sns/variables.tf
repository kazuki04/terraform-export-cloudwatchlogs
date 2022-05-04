variable "name" {
  description = "The name of topic"
  type        = string
  default     = "send_email_notification"
}

variable "email_address" {
  description = "Email address for endpoint"
  type        = string
  default     = "sample@gmail.com"
}
