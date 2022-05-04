import boto3

logs_client = boto3.client('logs')
TARGET_LOG_GROUPS = []

def describe_log_group_name():
    prefix = '/cloudwatch_logs/lambda'

    response = logs_client.describe_log_groups(
        logGroupNamePrefix=prefix
    )

    for log_group in response["logGroups"]:
        TARGET_LOG_GROUPS.append(
            {
                "log_group_name": log_group["logGroupName"],
                "prefix": log_group["logGroupName"]
            }
        )


def lambda_handler(event, context):
    describe_log_group_name()
    log_groups_count = len(TARGET_LOG_GROUPS)

    print(
        {
            "event": event,
            "target_log_groups": TARGET_LOG_GROUPS,
            "log_groups_count": log_groups_count
        }
    )

    return {
        "index": 0,
        "target_log_groups": TARGET_LOG_GROUPS,
        "log_group_count": log_groups_count
    }
