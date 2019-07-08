provider "aws" {
  region = "${var.region}"
}

resource "aws_instance" "test-ec2-1" {
  ami = "${var.ami}"
  instance_type   = "t1.micro"
  security_groups = ["${aws_security_group.instance.name}"]
  tags {
    Name = "test-ec2-1"
    environment = "playground"
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello from instance 1" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
}

resource "aws_instance" "test-ec2-2" {
  ami = "${var.ami}"
  instance_type   = "t1.micro"
  security_groups = ["${aws_security_group.instance.name}"]
  tags {
    Name = "test-ec2-2"
    environment = "playground"
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello from instance 2" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
}

resource "aws_instance" "test-ec2-3" {
  ami = "${var.ami}"
  instance_type   = "t1.micro"
  security_groups = ["${aws_security_group.instance.name}"]
  tags {
    Name = "test-ec2-3"
    environment = "playground"
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello from instance 3" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
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

resource "aws_elb" "http-lb" {
  name = "terraform-elb"
  availability_zones = ["eu-west-1a","eu-west-1b","eu-west-1c"]

  listener {
    instance_port = "${var.server_port}"
    instance_protocol = "http"
    lb_port = "${var.server_port_lb_http}"
    lb_protocol = "http"
  }

  instances = ["${aws_instance.test-ec2-1.id}","${aws_instance.test-ec2-2.id}","${aws_instance.test-ec2-3.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    name = "terraform-elb"
    environment = "playground"
  }
}
