locals {
  log_group_arn = aws_cloudwatch_log_group.sfn.arn
  role_name     = "StepFunctionsIAMRole"
  definition    = <<EOF
            {
          "StartAt": "Initialize",
          "TimeoutSeconds": 600,
          "States": {
            "Initialize": {
              "Type": "Task",
              "Resource": "${var.describe_log_groups_lambda_arn}",
              "ResultPath": "$.log_groups_info",
              "Next": "CreateExportTask"
            },
            "CreateExportTask": {
              "Type": "Task",
              "Resource": "${var.create_export_task_lambda_arn}",
              "ResultPath": "$.log_groups_info",
              "Next": "WaitFiveSeconds"
            },
            "DescribeExportTasks": {
              "Type": "Task",
              "Resource": "${var.describe_export_task_lambda_arn}",
              "ResultPath": "$.describe_export_task",
              "Next": "CheckStatusCode"
            },
            "CheckStatusCode": {
              "Type": "Choice",
              "Choices": [
                {
                  "Variable": "$.describe_export_task.status_code",
                  "StringEquals": "COMPLETED",
                  "Next": "IsAllLogsExported?"
                },
                {
                  "Or": [
                    {
                      "Variable": "$.describe_export_task.status_code",
                      "StringEquals": "PENDING"
                    },
                    {
                      "Variable": "$.describe_export_task.status_code",
                      "StringEquals": "RUNNING"
                    }
                  ],
                  "Next": "WaitFiveSeconds"
                }
              ],
              "Default": "ExportFailed"
            },
            "WaitFiveSeconds": {
              "Type": "Wait",
              "Seconds": 5,
              "Next": "DescribeExportTasks"
            },
            "IsAllLogsExported?": {
              "Type": "Choice",
              "Choices": [
                {
                  "Variable": "$.log_groups_info.completed_flag",
                  "BooleanEquals": true,
                  "Next": "Done"
                }
              ],
              "Default": "CreateExportTask"
            },
            "Done": {
              "Type": "Succeed"
            },
            "ExportFailed": {
              "Type": "Fail"
            }
          }
        }
    EOF
}

resource "aws_sfn_state_machine" "this" {
  name = var.name

  role_arn   = aws_iam_role.this.arn
  definition = local.definition

  logging_configuration {
      log_destination        = lookup(var.logging_configuration, "log_destination", "${local.log_group_arn}:*")
      include_execution_data = true
      level                  = "ALL"
  }

  type = upper(var.type)

  depends_on = [aws_cloudwatch_log_group.sfn]
}

###########
# IAM Role
###########
resource "aws_iam_role" "this" {
  name                  = local.role_name
  description           = var.role_description
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json

  inline_policy {
    name   = "excute_step_functions"
    policy = data.aws_iam_policy_document.inline_policy.json
  }

}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "inline_policy" {
  statement {
    effect = "Allow"
    actions   = [
      "logs:CreateLogDelivery",
      "logs:GetLogDelivery",
      "logs:UpdateLogDelivery",
      "logs:DeleteLogDelivery",
      "logs:ListLogDeliveries",
      "logs:PutResourcePolicy",
      "logs:DescribeResourcePolicies",
      "logs:DescribeLogGroups"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions   = ["lambda:InvokeFunction"]
    resources = [
        "*"
    ]
  }
}

##################
# CloudWatch Logs
##################

# data "aws_cloudwatch_log_group" "sfn" {
#   name = var.cloudwatch_log_group_name
# }

resource "aws_cloudwatch_log_group" "sfn" {
  name              = "/aws/sfn/${var.name}"
}
