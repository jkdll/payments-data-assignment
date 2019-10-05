/*
* Terraform Resources for AWS Secrets Manager
* Resource: https://www.terraform.io/docs/providers/aws/r/secretsmanager_secret.html
*/
/*
resource "aws_secretsmanager_secret" "asm_redshift_db_pw" {
  name        = "${var.redshift_username}"
  description = "Redshift Database Secret"
}

resource "aws_secretsmanager_secret_version" "asm_redshift_secret_version" {
  secret_id     = "${aws_secretsmanager_secret.asm_redshift_db_pw.id}"
  secret_string = "${var.redshift_password}"
}
*/

resource "aws_key_pair" "keypair" {
  key_name   = "kp-${var.module_name}"
  public_key = "${file("${path.module}/keys/jkdll.pub")}"
}
