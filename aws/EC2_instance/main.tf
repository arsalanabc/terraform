provider "aws" {
  region = "${var.region}"
}

resource "aws_security_group" "instance" {
  name = "terraform-example-sg"
  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    environment = "playground"
  }
}

resource "aws_launch_configuration" "instance_config" {
  name_prefix     = "cluster-"
  image_id        = "${var.ami}"
  instance_type   = "t1.micro"
  security_groups = ["${aws_security_group.instance.name}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello from instance 3" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_availability_zones" "all" {}

resource "aws_autoscaling_group" "instance_asg" {
  launch_configuration  = "${aws_launch_configuration.instance_config.id}"
  availability_zones    = ["${data.aws_availability_zones.all.names}"]
  min_size              = 2
  max_size              = 5

  load_balancers        = ["${aws_elb.http-lb.name}"]
  tag {
    key                 = "name"
    propagate_at_launch = true
    value               = "Instance_terraform_asg"
  }
}

resource "aws_elb" "http-lb" {
  name = "terraform-elb"
  availability_zones  = ["${data.aws_availability_zones.all.names}"]

  listener {
    instance_port = "${var.server_port}"
    instance_protocol = "http"
    lb_port = "${var.server_port_lb_http}"
    lb_protocol = "http"
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    name = "terraform-elb"
    environment = "playground"
  }
}
