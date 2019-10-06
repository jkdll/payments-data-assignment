resource "aws_emr_cluster" "emr-spark-cluster" {
  name                              = "flink-emr-cluster"
  release_label                     = "emr-5.27.0"
  applications                      = ["Flink"]
  termination_protection            = false
  keep_job_flow_alive_when_no_steps = true

  ec2_attributes {
    subnet_id                         = "${data.aws_subnet.default_subnet.id}"
    key_name                          = "kp-${var.module_name}"
    emr_managed_master_security_group = "${data.aws_security_group.default_sg.id}"
    emr_managed_slave_security_group  = "${data.aws_security_group.default_sg.id}"
    instance_profile                  = "${aws_iam_instance_profile.emr_profile.arn}"
  }

  ebs_root_volume_size = "12"

  master_instance_type = "m5.xlarge"
  core_instance_type   = "m5.xlarge"
  core_instance_count  = 1

  service_role = "${aws_iam_role.firehose_role.arn}"

  bootstrap_action {
    name = "Bootstrap setup."
    path = "s3://${var.env}-s3-${var.module_name}/scripts/emr-bootstrap.sh"
  }

  depends_on = ["aws_s3_bucket_object.object"]

  configurations_json = <<EOF
    [
    {
    "Classification": "flink-conf",
      "Properties": {
      "taskmanager.numberOfTaskSlots":"2"
      }
    }
  ]
EOF
}
