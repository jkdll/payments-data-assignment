"""
Simple script to generate a list of test card numbers
Author: Jake Dalli
"""
import random
import numpy
from cardgen_lib import load_data
from cardgen_lib import generate_card
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('TOTAL_CARDS', metavar='TOTAL_CARDS', type=int, help= 'Number of Cards to Generate')
parser.add_argument('PERCENTAGE_STOLEN', metavar='PERCENTAGE_STOLEN', type=float, help= 'Percentage of stolen cards in decimal')
parser.add_argument('OUTPUT', metavar='OUTPUT', type=str, help= "File to output to")
parser.add_argument('BATCH_COUNT', metavar='BATCH_COUNT', type=int, help= "Number of Batches to process")
args = parser.parse_args()


# Total number of Cards to generate
TOTAL_CARDS = args.TOTAL_CARDS
# Percentage of test cards to generate
PERCENTAGE_STOLEN = args.PERCENTAGE_STOLEN
# Index cutoff for test cards
STOLEN_CARDS = int(TOTAL_CARDS*PERCENTAGE_STOLEN)
# Output File Path
FILE_PATH = args.OUTPUT
# We write cards in batch to avoid memory overflow when generating large files
BATCH_COUNT = args.BATCH_COUNT
BATCH_SIZE = int(TOTAL_CARDS/BATCH_COUNT)

# Get Card Provider Data
providers = load_data('provider_data.json')

# We generate cards based on probability distribution
# Get Provider List and Probability Distribution
provider_list = []
provider_prob = []

for p in providers:
	provider_list.append(providers[p]['name'])
	provider_prob.append(providers[p]['probability'])

# Open File and write header
file = open(FILE_PATH,"w+")
file.write("provider,card_number,is_stolen\n")

# Batch Card Generation
for b in range(0,BATCH_SIZE):
	idx_stolen = int(BATCH_COUNT*PERCENTAGE_STOLEN)
	lines = []
	for i in range(0,BATCH_COUNT):
		# Select a provider based on probability distribution
		choice = numpy.random.choice(provider_list, p=provider_prob)
		length = providers[choice]['length']
		iin = random.choice(providers[choice]['iin'])
		luhn = providers[choice]['luhn']
		card_number = generate_card(length,iin,luhn)
		if i <= idx_stolen:
			test_card = '1'
		else:
			test_card = '0'
		lines.append(choice + ',' + card_number + "," + test_card + "\n")
	
	# Jumble order of batch and write to file
	lines = sorted(lines, key = lambda x: random.random() )
	file.writelines(lines)

file.close()