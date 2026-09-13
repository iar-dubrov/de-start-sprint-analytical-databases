import pendulum
import pandas as pd
import vertica_python

from airflow.decorators import dag
from airflow.operators.python import PythonOperator

conn_info = {
    'host': 'vertica.data-engineer.education-services.ru',
    'port': 5433,
    'user': 'vt260909ee3191',
    'password': 'a8ae08e092494c55a15288f46777bb90',
    'database': 'dwh',
    'autocommit': True,
}


def load_group_log():
    df = pd.read_csv('/data/group_log.csv')
    df['user_id_from'] = pd.array(df['user_id_from'], dtype="Int64")

    cols = ['group_id', 'user_id', 'user_id_from', 'event', 'datetime']
    buf = df[cols].to_csv(index=False, header=False)

    copy_sql = """
        COPY VT260909EE3191__STAGING.group_log
             (group_id, user_id, user_id_from, event, "datetime")
        FROM STDIN DELIMITER ',' NULL '' ABORT ON ERROR
    """

    with vertica_python.connect(**conn_info) as conn:
        cur = conn.cursor()
        cur.execute('TRUNCATE TABLE VT260909EE3191__STAGING.group_log')
        cur.copy(copy_sql, buf)
        conn.commit()


@dag(schedule_interval=None, start_date=pendulum.parse('2022-07-13'))
def project_load_group_log():
    PythonOperator(task_id='load_group_log', python_callable=load_group_log)


_ = project_load_group_log()