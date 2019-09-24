/*
* Terraform Resources for S3
* Resource: https://www.terraform.io/docs/providers/aws/r/s3_bucket.html
*/

resource "aws_s3_bucket" "logging_bucket" {
  bucket = "${var.env}-s3-${var.module_name}"
  acl    = "private"

  tags = {
    Name        = "${var.env}-s3-${var.module_name}"
    Environment = "${var.env}"
  }
}
