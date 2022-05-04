resource "aws_sns_topic" "send_email_notification_topic" {
  name = var.name
}

resource "aws_sns_topic_subscription" "send_email_notification_subscription" {
  topic_arn = aws_sns_topic.send_email_notification_topic.arn
  protocol  = "email"
  endpoint  = var.email_address
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.send_email_notification_topic.arn

  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Publish",
    ]

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.send_email_notification_topic.arn,
    ]
  }
}
