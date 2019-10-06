/*
* Input Parameters for Terraform Setup
*/

// Project Secret Variables - populate via io-variables-secrets.tfvars

variable "aws_secret_key" {
  type = "string"
}

variable "aws_access_key" {
  type = "string"
}

variable "aws_region" {
  type = "string"
}

variable "redshift_username" {
  type = "string"
}

variable "redshift_password" {
  type = "string"
}

// Project Input Variables - populate via io-variables-project.tfvars

variable "env" {
  default = "d"
  type    = "string"
}

variable "module_name" {
  default = "payments-data-poc"
  type    = "string"
}

variable "kinesis_payments_name" {
  default = "d-kinesis-payments-data-poc"
  type    = "string"
}

variable "kinesis_fh_input_name" {
  default = "d-fh-payments-data-poc"
  type    = "string"
}

variable "security_group_id" {
  default = "sg-bfe09ee6"
}

variable "vpc_id" {
  default = "vpc-35069b4f"
}

variable "subnet_id" {
  default = "subnet-4e487241"
}
