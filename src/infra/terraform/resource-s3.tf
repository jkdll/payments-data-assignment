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

resource "aws_s3_bucket_object" "object" {
<<<<<<< HEAD
  bucket = "${aws_s3_bucket.logging_bucket.id}"

=======
  bucket = "${var.env}-s3-${var.module_name}"
>>>>>>> 0c6597f698e332d14b68f2124b3f21fcc86cc2fd
  key    = "scripts/emr-bootstrap.sh"
  source = "scripts/emr-bootstrap.sh"
}
