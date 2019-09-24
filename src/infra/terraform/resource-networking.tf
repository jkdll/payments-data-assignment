/*
* Terraform Resources for Networking
*/

resource "aws_vpc" "payments_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "payments-poc-vpc"
  }
}

resource "aws_subnet" "payments-sn" {
  vpc_id = "${aws_vpc.payments_vpc.id}"

  cidr_block = "10.0.0.0/16"
}
