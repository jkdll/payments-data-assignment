/*
* Output Parameters for Terraform Setup
*/

output "redshift_endpoint" {
  value = "${aws_redshift_cluster.redshift_cluster.endpoint}"
}

output "redshift_db" {
  value = "${aws_redshift_cluster.redshift_cluster.database_name}"
}

output "redshift_un" {
  value = "${aws_redshift_cluster.redshift_cluster.master_username}"
}

output "redshift_pw" {
  value = "${aws_redshift_cluster.redshift_cluster.master_password}"
}

output "aws_region" {
  value = "${var.aws_region}"
}

output "aws_access_key" {
  value = "${var.aws_access_key}"
}

output "aws_secret_key" {
  value = "${var.aws_secret_key}"
}

output "kinesis_stream" {
  value = "${aws_kinesis_stream.payments-data-stream.name}"
}
