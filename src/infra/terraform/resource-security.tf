/*
* Terraform Resources for Security
*/

resource "aws_iam_role" "firehose_role" {
  name = "firehose_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "firehose.amazonaws.com",
          "redshift.amazonaws.com",
          "elasticmapreduce.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "iamr_pa_admin" {
  role       = "${aws_iam_role.firehose_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "imar_pa_redshift" {
  role       = "${aws_iam_role.firehose_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonRedshiftFullAccess"
}

resource "aws_iam_role_policy_attachment" "iamr_pa_s3" {
  role       = "${aws_iam_role.firehose_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "iamr_pa_emr" {
  role       = "${aws_iam_role.firehose_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceRole"
}

resource "aws_iam_instance_profile" "emr_profile" {
  name = "emr_profile"
  role = "${aws_iam_role.firehose_role.name}"
}

resource "aws_s3_bucket_policy" "b" {
  bucket = "${aws_s3_bucket.logging_bucket.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "MYBUCKETPOLICY",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::536530796165:role/firehose_role"
      },
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::${var.env}-s3-${var.module_name}/*"
    }
  ]
}
POLICY
}
