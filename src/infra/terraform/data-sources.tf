data "aws_vpc" "default_vpc" {
  id = "${var.vpc_id}"
}

data "aws_subnet" "default_subnet" {
  id = "${var.subnet_id}"
}

data "aws_security_group" "default_sg" {
  id = "${var.security_group_id}"
}
