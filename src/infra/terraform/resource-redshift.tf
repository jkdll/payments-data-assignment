/*
* Terraform Resources for Redshift
* Resource: https://www.terraform.io/docs/providers/aws/d/redshift_cluster.html
*/

resource "aws_redshift_cluster" "redshift_cluster" {
  cluster_identifier = "${var.env}-redshift-${var.module_name}"
  database_name      = "${var.env}_payments_poc"
  master_username    = "${var.redshift_username}"
  master_password    = "${aws_secretsmanager_secret_version.asm_redshift_secret_version.secret_string}"
  node_type          = "dc1.large"
  cluster_type       = "single-node"
}
