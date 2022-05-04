output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."
  value       = aws_s3_bucket.lambda_bucket.id
}

output "describe_log_groups" {
  value = aws_s3_object.describe_log_groups.id
}

output "create_export_task" {
  value = aws_s3_object.create_export_task.id
}

output "describe_export_task" {
  value = aws_s3_object.describe_export_task.id
}
