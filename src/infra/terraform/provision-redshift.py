import psycopg2
import json


def get_cloud_info(location):
	"""
	This method parses terraform output in json into a dictionary.
	"""
	params = dict()
	# Read in the file
	with open(location, 'r') as myfile: data=myfile.read()
	obj = json.loads(data)
	for o in obj:
		params[o] = obj[o]['value']
	return params

details = get_cloud_info('infra_values.json')

conn = psycopg2.connect("dbname="+details['redshift_db']+" host="+details['redshift_endpoint'].split(":")[0] 
	+" port=5439 user="+details['redshift_un']+" password="+details['redshift_pw']+"")
cur = conn.cursor()

cur.execute("CREATE SCHEMA IF NOT EXISTS dw_core AUTHORIZATION "+details['redshift_un']+ ";") 
cur.execute("CREATE TABLE IF NOT EXISTS dw_core.fact_payment ( event VARCHAR(255), event_date_origin TIMESTAMP, event_dw_regdate TIMESTAMP DEFAULT sysdate, event_json_data VARCHAR(5000));")
cur.execute("COMMIT;")

conn.close()