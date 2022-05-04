resource "aws_cloudwatch_event_rule" "fail_or_time_out_notification_event_rule" {
  name                 = "ExportCloudWatchLogsToS3"
  event_pattern        = <<EOF
{
  "source": ["aws.states"],
  "detail-type": ["Step Functions Execution Status Change"],
  "detail": {
    "status": ["FAILED", "TIMED_OUT"],
    "stateMachineArn": [${var.state_machine_arn}]
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "this" {
  rule      = aws_cloudwatch_event_rule.fail_or_time_out_notification_event_rule.name
  arn       = var.sns_topic_arn
}
