/*
* Terraform Resources for Firehose
* Reference:
* https://www.terraform.io/docs/providers/aws/r/kinesis_firehose_delivery_stream.html
*/

resource "aws_kinesis_firehose_delivery_stream" "redshift_stream" {
  name        = "${var.env}-kinesis-firehose-redshift-stream-${var.module_name}"
  destination = "redshift"

  s3_configuration {
    role_arn           = "${aws_iam_role.firehose_role.arn}"
    bucket_arn         = "${aws_s3_bucket.logging_bucket.arn}"
    buffer_size        = 10
    buffer_interval    = 400
    compression_format = "GZIP"
  }

  redshift_configuration {
    role_arn        = "${aws_iam_role.firehose_role.arn}"
    cluster_jdbcurl = "jdbc:redshift://${aws_redshift_cluster.redshift_cluster.endpoint}/${aws_redshift_cluster.redshift_cluster.database_name}"

    username           = "${var.redshift_username}"
    password           = "${aws_secretsmanager_secret_version.asm_redshift_secret_version.secret_string}"
    data_table_name    = "dw_core.fact_payment"
    copy_options       = "delimiter '|'"
    data_table_columns = "event_date_origin,event_dw_regdate,event_json_data"
    s3_backup_mode     = "Enabled"

    s3_backup_configuration {
      role_arn           = "${aws_iam_role.firehose_role.arn}"
      bucket_arn         = "${aws_s3_bucket.logging_bucket.arn}"
      buffer_size        = 15
      buffer_interval    = 300
      compression_format = "GZIP"
    }
  }
}
