import json
from random import randint

def load_data(path):
	with open(path) as json_file:
		# Load Data
		data = json.load(json_file)

		# Variable to Ensure that the total distribution amounts to 1
		total_dist = 0

		# List to store provider data
		providers = {}

		# For every distrubiton value - load the data
		for provider in data['distribution']:
			temp_provider = {}
			total_dist = total_dist + data['distribution'][provider] 

			if provider not in data['provider']:
				raise ValueError('Incomplete Provider Data')
			else:
				# Add Data
				temp_provider['name'] = provider
				temp_provider['probability'] =  data['distribution'][provider] 
				temp_provider['length'] = data['provider'][provider]['length']
				temp_provider['iin'] = data['provider'][provider]['iin']
				temp_provider['luhn'] = True if data['provider'][provider]['validation'] == 'luhn' else False
				providers[provider] =  temp_provider
		
		if total_dist != 1:
			raise ValueError('Incorrect Distribution Data')
		else:
			return providers



def generate_card(length, iin, luhn):
	card_number = ""
	# Reserve 1 Digit for Luhn Verification
	if luhn is True:
		length = length - 1

	# Generate Full IIN - Max Length: 6 digits
	if len(iin) < 6:
		card_number += iin
		for n in range(0,6-len(iin)): 
			card_number += str(randint(0, 9))

	length = length - 6

	# Generate Rest of Number
	for n in range(0,length):
		card_number += str(randint(0, 9))

	# Generate Luhn Check Number
	luhn_total = 0
	reversed_card_number = card_number[::-1]
	for i in range(0,len(reversed_card_number)):
		digit = int(reversed_card_number[i])
		
		if i%2==0:
			multiplier = digit*2
			if multiplier > 9:
				multiplier = int(str(multiplier)[0]) + int(str(multiplier)[1])
		
		else:
			multiplier = digit

		luhn_total += multiplier

	# Compute Check Digit and add to card number
	card_number += str(luhn_total*9)[-1]
	return (card_number)