import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):
    for record in event.get('Records', []):
        bucket = record['s3']['bucket']['name']
        key    = record['s3']['object']['key']
        logger.info(f'Image received: {key}')
        logger.info(f'Bucket: {bucket}, Size: {record["s3"]["object"].get("size", 0)} bytes')
    return {'statusCode': 200, 'body': json.dumps('Processed successfully')}

