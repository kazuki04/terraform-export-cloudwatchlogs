data "aws_partition" "current" {}

locals {
  # s3_* - to get package from S3
#   s3_bucket         = var.s3_existing_package != null ? try(var.s3_existing_package.bucket, null) : (var.store_on_s3 ? var.s3_bucket : null)
#   s3_key            = var.s3_existing_package != null ? try(var.s3_existing_package.key, null) : (var.store_on_s3 ? var.s3_prefix != null ? format("%s%s", var.s3_prefix, replace(local.archive_filename_string, "/^.*//", "")) : replace(local.archive_filename_string, "/^\\.//", "") : null)
#   s3_object_version = var.s3_existing_package != null ? try(var.s3_existing_package.version_id, null) : (var.store_on_s3 ? try(aws_s3_object.lambda_package[0].version_id, null) : null)
}

resource "aws_lambda_function" "this" {
  function_name                  = var.function_name
  description                    = var.description
  handler                        = var.handler
  runtime                        = var.runtime
  role                           = aws_iam_role.lambda.arn

#   s3_bucket         = local.s3_bucket
#   s3_key            = local.s3_key
#   s3_object_version = local.s3_object_version

    s3_bucket = var.lambda_bucket_name
  s3_key    = var.object_key

  # Depending on the log group is necessary to allow Terraform to create the log group before AWS can.
  # When a lambda function is invoked, AWS creates the log group automatically if it doesn't exist yet.
  # Without the dependency, this can result in a race condition if the lambda function is invoked before
  # Terraform can create the log group.
  depends_on = [aws_cloudwatch_log_group.lambda]
}

# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
# If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.function_name}"
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
