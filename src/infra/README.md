# Infrastructure Setup

This folder contains the infrasturcture setup using Terraform 11. All terraform scripts are found in the terraform folder.

## Setup

To set up the infrastructure you should create a tfvars file called 'io-values-secrts.tfvars' used to supply the secrets.
It should be structured as follows:
```
aws_access_key = "<aws_access_key>"
aws_secret_key = "<aws_secret_key>"
aws_region = "<aws_region>"

redshift_username = "<redshift_username>"
redshift_password = "<redhift_password>"
```

## Infrastructure Provisioned

The infrastructure deployed includes:
- Single Node Redshift Cluster
- Kinesis Stream
- Kinesis Firehose Delivery System Redshift
- S3 Bucket containing the intermediate data published to Redshift
- AWS EMR cluster


