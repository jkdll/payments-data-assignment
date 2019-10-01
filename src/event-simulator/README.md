# Event Simulator
This directory contains the code for the event simulator; the purpose is to carry out the following actions:

- Generate a list of bank cards, marking an arbitrary amount as stolen.

- Generate payment events using the bank card list to a kinesis stream.

Below is a brief description of the components.

## Card Generator

The contents of this module are found within the `card-generator` directory of this directory.

We generate a list of *X* cards using a user-specified distribution.

The card generator is run using the following command:

```python3 cardgen.py <number_of_cards> <percentage_test> <output_file> <batch_size>```

For example:

```python3 cardgen.py 50000 0.1 cards2.csv 5```

The batch size is used to determine when to write cards to the file, in order to write data periodically. This is useful when generating large lists of cards.

Cards are generated based on a specified format within `provider_data.json` - this JSON file contains a list of providers and details regarding the cards they issued. Such details include the card number length, iin prefix, and whether the card number uses a luhn checksum. 

Moreover, we also specify the marketshare of each provider in order to generate cards according to the marketshare distribution.

Two notes on the file:

- Marketshare is described using a descimal percentage (ex. 0.1 for 10%). The total distribution **for all providers** must equal to 1. 

- Every provider must have the following details specified:

	- Length of Bank Cards (Integer) 

	- Array of potential IIN prefixes (Array of String)

	- Validation value (one possible value "luhn")

- For every specified provider, there must be a *distribution* defined. 


The card generator makes use of a JSON file of the following format:

```
{
   "distribution":{
   		<provider> : <percentage_distribution>
   },

   "provider":{
      <provider> :{
         "length": <card_length>,
         "iin":[
            <iin>
         ],
         "validation":<luhn>
      }
  }
```

## Kinesis Producer


