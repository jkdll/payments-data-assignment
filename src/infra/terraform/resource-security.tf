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
