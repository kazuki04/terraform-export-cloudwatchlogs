provider "aws" {
  profile = var.profile
  region = var.aws_region
}

module "s3" {
    source = "./modules/s3/exported-bucket"
}

module "lambda-bucket" {
    source = "./modules/s3/lambda-bucket"
}

module "describe_log_groups_lambda" {
    source = "./modules/lambda/describe_log_groups"
    lambda_bucket_name = module.lambda-bucket.lambda_bucket_name
    object_key = module.lambda-bucket.describe_log_groups
}

module "create_export_task_lambda" {
    source = "./modules/lambda/create_export_task"
    bucket_name = module.s3.bucket_name
    lambda_bucket_name = module.lambda-bucket.lambda_bucket_name
    object_key = module.lambda-bucket.create_export_task
}

module "describe_export_task_lambda" {
    source = "./modules/lambda/describe_export_task"
    lambda_bucket_name = module.lambda-bucket.lambda_bucket_name
    object_key = module.lambda-bucket.describe_export_task
}

module "send_notification_to_slack_lambda" {
    source = "./modules/lambda/send_notification_to_slack"
    lambda_bucket_name = module.lambda-bucket.lambda_bucket_name
    object_key = module.lambda-bucket.send_notification_to_slack
}

module "step_functions" {
    source = "./modules/step-functions"
    describe_log_groups_lambda_arn = module.describe_log_groups_lambda.arn
    create_export_task_lambda_arn = module.create_export_task_lambda.arn
    describe_export_task_lambda_arn = module.describe_export_task_lambda.arn
    send_notification_to_slack_lambda_arn = module.send_notification_to_slack_lambda.arn
}

module "event_bridge" {
    source = "./modules/event-bridge"
    step_functions_arn = module.step_functions.step_functions_arn
}
