import json
import os
import urllib3
http = urllib3.PoolManager()


def lambda_handler(event, context):
    url = os.environ["WEBHOOK_URL"]
    slack_channel = os.environ["SLACK_CHANNEL"]
    msg = {
        "channel": slack_channel,
        "text": "Step Functionsの処理が失敗しました。"
    }

    encoded_msg = json.dumps(msg).encode('utf-8')
    response = http.request('POST', url, body=encoded_msg)

    print(
        {
            "status_code": response.status,
            "response": response.data,
        }
    )
