variable "server_port" {
  description = "Port to allow income/outgoing requests"
  default     = "8080"
}

variable "server_port_lb" {
  description = "Port to allow income/outgoing request to lb"
  default     = "80"
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "test-ec2-1" {
  ami = "ami-ee0b0688"
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
  ami = "ami-ee0b0688"
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
  ami = "ami-ee0b0688"
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
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 80
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
