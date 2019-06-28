variable "server_port" {
  description = "Port to allow income/outgoing requests"
  default     = "8080"
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
}