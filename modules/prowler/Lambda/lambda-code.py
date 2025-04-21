import boto3
import subprocess
import os
import datetime

s3 = boto3.client('s3')
bucket = os.environ['BUCKET_NAME']

def lambda_handler(event, context):
    timestamp = datetime.datetime.utcnow().strftime('%Y-%m-%dT%H-%M-%SZ')
    output_file = f'/tmp/prowler-report-{timestamp}.json'
    s3_key = f'prowler/reports/prowler-report-{timestamp}.json'

    try:
        # Run Prowler
        subprocess.run(
            ["./prowler", "-M", "json", "-S", "-o", output_file],
            check=True
        )

        # Upload result to S3
        with open(output_file, 'rb') as f:
            s3.upload_fileobj(f, bucket, s3_key)

        return {
            'statusCode': 200,
            'body': f'Successfully ran Prowler and uploaded to {s3_key}'
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': str(e)
        }
