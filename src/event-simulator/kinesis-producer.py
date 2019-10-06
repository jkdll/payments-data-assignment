import random
import json
from datetime import datetime
import boto3
import time

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

details = get_cloud_info('../infra/terraform/infra_values.json')

FILE_PATH = 'card-generator/cards.csv'
# Get Row Count
file = open(FILE_PATH)
row_count = sum(1 for row in file)

stream_name = details['kinesis_stream']

client = boto3.client(
    'kinesis',
    region_name = details['aws_region'],
    aws_access_key_id = details['aws_access_key'],
    aws_secret_access_key = details['aws_secret_key']
)

while True:
	idx_card = random.randint(1,row_count)
	for i in range(1,row_count):
		line = file.readline()
		if i == idx_card and len(line) > 0:
			values = line.split(',')
			cardno = values[1]
			stolen = values[2]
			event_timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
			partitionkey = datetime.now().strftime("%Y%m%d")
			amount = round(random.uniform(5.0,1000.0),2)
			# Build JSON
			data = {}
			data['event'] = 'PAYMENT_EVENT'
			data['event_timestamp'] = event_timestamp
			data['card_number'] = cardno
			data['amount'] = amount
			data['stolen'] = int(stolen)
			data_string = data['event']+'|'+data['event_timestamp']+'|' + json.dumps(data) + '\n'
			print('Sending Message: "' + data_string + '"')
			client.put_record(StreamName=stream_name, Data=data_string.encode('utf-8'), PartitionKey=partitionkey)
			break

	file.seek(0)
	time.sleep(10)

