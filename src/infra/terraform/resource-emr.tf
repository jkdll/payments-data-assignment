resource "aws_emr_cluster" "emr-spark-cluster" {
  name                              = "flink-emr-cluster"
  release_label                     = "emr-5.27.0"
  applications                      = ["Flink"]
  termination_protection            = false
  keep_job_flow_alive_when_no_steps = true

  ec2_attributes {
    subnet_id                         = "${aws_subnet.payments-sn.id}"
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

  /*step = [
    {
      name              = "Copy script file from s3."
      action_on_failure = "CONTINUE"

      hadoop_jar_step {
        jar  = "command-runner.jar"
        args = ["aws", "s3", "cp", "s3://${var.name}/scripts/pyspark_quick_setup.sh", "/home/"]
      }
    },
    {
      name              = "Setup pyspark with conda."
      action_on_failure = "CONTINUE"

      hadoop_jar_step {
        jar  = "command-runner.jar"
        args = ["sudo", "bash", "/home/hadoop/pyspark_quick_setup.sh"]
      }
    },
  ]*/

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
