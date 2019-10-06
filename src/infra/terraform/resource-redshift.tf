/*
* Terraform Resources for Redshift
* Resource: https://www.terraform.io/docs/providers/aws/d/redshift_cluster.html
*/

resource "aws_redshift_cluster" "redshift_cluster" {
  cluster_identifier  = "${var.env}-redshift-${var.module_name}"
  database_name       = "${var.env}_payments_poc"
  master_username     = "${var.redshift_username}"
  master_password     = "${var.redshift_password}"
  node_type           = "dc1.large"
  cluster_type        = "single-node"
  skip_final_snapshot = "True"
  iam_roles           = ["${aws_iam_role.firehose_role.arn}"]
}
