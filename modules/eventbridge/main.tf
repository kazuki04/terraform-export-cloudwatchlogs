resource "aws_cloudwatch_event_rule" "this" {
  name        = "ExportCloudWatchLogsToS3"

  schedule_expression = "cron(0 21 * * ? *)"
}

resource "aws_cloudwatch_event_target" "this" {
  rule      = aws_cloudwatch_event_rule.this.name
  arn       = var.step_functions_arn
  role_arn            = aws_iam_role.event_bridge.arn
}

resource "aws_iam_role" "event_bridge" {
  name                  = var.role_name
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json

  inline_policy {
    name   = "create_export_task"
    policy = data.aws_iam_policy_document.inline_policy.json
  }

}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "inline_policy" {
  statement {
      actions = [
          "states:StartExecution"
      ]
      resources = [var.step_functions_arn]
  }
}
