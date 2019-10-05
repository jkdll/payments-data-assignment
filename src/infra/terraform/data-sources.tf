data "aws_security_group" "default_sg" {
  id = "${var.security_group_id}"
}
