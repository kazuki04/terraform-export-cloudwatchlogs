resource "aws_s3_bucket" "lambda_bucket" {
  bucket = var.bucket

  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.lambda_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_object" "describe_log_groups" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "describe_log_groups.zip"
  source = data.archive_file.describe_log_groups.output_path

  etag = filemd5(data.archive_file.describe_log_groups.output_path)
}

resource "aws_s3_object" "create_export_task" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "create_export_task.zip"
  source = data.archive_file.create_export_task.output_path

  etag = filemd5(data.archive_file.create_export_task.output_path)
}

resource "aws_s3_object" "describe_export_task" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "describe_export_task.zip"
  source = data.archive_file.describe_export_task.output_path

  etag = filemd5(data.archive_file.describe_export_task.output_path)
}

data "archive_file" "describe_log_groups" {
  type = "zip"

  source_file = "${path.module}/lambda/describe_log_groups.py"
  output_path = "${path.module}/files/describe_log_groups.zip"
}

data "archive_file" "create_export_task" {
  type = "zip"

  source_file = "${path.module}/lambda/create_export_task.py"
  output_path = "${path.module}/files/create_export_task.zip"
}

data "archive_file" "describe_export_task" {
  type = "zip"

  source_file = "${path.module}/lambda/describe_export_task.py"
  output_path = "${path.module}/files/describe_export_task.zip"
}
