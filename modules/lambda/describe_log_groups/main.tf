resource "aws_lambda_function" "this" {
  function_name                  = var.function_name
  description                    = var.description
  handler                        = var.handler
  runtime                        = var.runtime
  role                           = aws_iam_role.lambda.arn

  s3_bucket = var.lambda_bucket_name
  s3_key    = var.object_key

  depends_on = [aws_cloudwatch_log_group.lambda]
}

resource "aws_cloudwatch_log_group" "lambda" {
  name = "/aws/lambda/${var.function_name}"
}

resource "aws_iam_role" "lambda" {
  name                  = var.role_name
  description           = var.role_description
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
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "inline_policy" {
  statement {
      actions = [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups"
      ]
      resources = ["*"]
  }
}
