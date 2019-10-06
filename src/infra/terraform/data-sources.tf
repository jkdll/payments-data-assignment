<<<<<<< HEAD
data "aws_vpc" "default_vpc" {
  id = "${var.vpc_id}"
}

data "aws_subnet" "default_subnet" {
  id = "${var.subnet_id}"
}

=======
>>>>>>> 0c6597f698e332d14b68f2124b3f21fcc86cc2fd
data "aws_security_group" "default_sg" {
  id = "${var.security_group_id}"
}
