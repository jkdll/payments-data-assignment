/*
* Terraform Resources for Kinesis
* Reference: https://www.terraform.io/docs/providers/aws/r/kinesis_stream.html
*/

resource "aws_kinesis_stream" "payments-data-stream" {
  name             = "${var.kinesis_payments_name}"
  shard_count      = 1
  retention_period = 48

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  tags = {
    Name        = "${var.kinesis_payments_name}"
    Environment = "${var.env}"
  }
}
