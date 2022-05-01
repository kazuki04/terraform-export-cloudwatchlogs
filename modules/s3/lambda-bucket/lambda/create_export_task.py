import boto3
import datetime
import os
from typing import Tuple

logs_client = boto3.client('logs')
S3_BUCKET_NAME = os.environ["BUCKET_NAME"]

def specify_time_range_for_export(today: datetime.date) -> Tuple[int, int]:
    today_datetime= datetime.datetime(year=today.year, month=today.month, day=today.day, hour=0, minute=0, second=0)

    from_time = today_datetime - datetime.timedelta(days=1, hours=9)
    to_time = today_datetime - datetime.timedelta(hours=9)

    # create_export_taskでは、時刻をmillisecondsで表す必要があるためキャストしている
    milliseconds_from_time = int(from_time.timestamp() * 1000)
    milliseconds_to_time = int(to_time.timestamp() * 1000)

    return milliseconds_from_time, milliseconds_to_time


def lambda_handler(event, context):
    index = event['log_groups_info']['index']
    log_groups_count = event["log_groups_info"]["log_group_count"]

    today = datetime.date.today()
    yesterday = today - datetime.timedelta(days=1)
    TARGET_LOG_GROUPS = event["log_groups_info"]["target_log_groups"]

    from_time, to_time = specify_time_range_for_export(today)

    response = logs_client.create_export_task(
        logGroupName=TARGET_LOG_GROUPS[index]['log_group_name'],
        fromTime=from_time,
        to=to_time,
        destination=S3_BUCKET_NAME,
        destinationPrefix=yesterday.strftime('{}/%Y/%m/%d'.format(TARGET_LOG_GROUPS[index]['prefix']))
    )

    index += 1

    print(
        {
            "event": event,
            "response": response
        }
    )
    
    return {
        "index": index,
        "completed_flag": index == log_groups_count,
        "task_id": response['taskId'],
        "log_group_count": log_groups_count,
        "target_log_groups": TARGET_LOG_GROUPS
    }
