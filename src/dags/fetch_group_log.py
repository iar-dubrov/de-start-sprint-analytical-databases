import pendulum

from airflow.decorators import dag
from airflow.operators.python import PythonOperator

import boto3


def fetch_s3_file(bucket: str, key: str):
    aws_access_key_id = "YCAJEiyNFq4wiOe_eMCMCXmQP"
    aws_secret_access_key = "YCP1e96y4QI8OmcB4Eaf4q0nMHwhmtvGbDTgBeqS"

    session = boto3.session.Session()
    s3_client = session.client(
        service_name='s3',
        endpoint_url='https://storage.yandexcloud.net',
        aws_access_key_id=aws_access_key_id,
        aws_secret_access_key=aws_secret_access_key,
    )
    s3_client.download_file(Bucket=bucket, Key=key, Filename=f'/data/{key}')


@dag(schedule_interval=None, start_date=pendulum.parse('2022-07-13'))
def project_get_group_log():
    PythonOperator(
        task_id='fetch_group_log',
        python_callable=fetch_s3_file,
        op_kwargs={'bucket': 'sprint6', 'key': 'group_log.csv'},
    )


_ = project_get_group_log()