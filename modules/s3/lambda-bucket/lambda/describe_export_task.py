import boto3

logs_client = boto3.client('logs')


def lambda_handler(event, context):
    task_id = event['log_groups_info']['task_id']
    response = logs_client.describe_export_tasks(
        taskId=task_id
    )

    status_code = response['exportTasks'][0]['status']['code']

    print(
        {
            "event": event,
            "Task ID": task_id,
            'Status Code': status_code
        }
    )

    return {
        'status_code': status_code
    }
