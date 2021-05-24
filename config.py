from dotenv import load_dotenv
load_dotenv()
import os

SMM_AUTH_TOKEN = os.environ.get("smm_auth_token")
OPEN_EXCHANGE_API = os.environ.get("app_id")

SQL_USER = os.environ.get("sql_user")
SQL_PASSWD = os.environ.get("sql_passwd")
SQL_PORT = os.environ.get("sql_port")

