provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "test" {
  ami = "ami-ee0b0688"
  instance_type = "t1.micro"
  security_groups = ["${aws_security_group.instance.name}"]
  tags {
    Name = "test-ec2"
  }

  user_data = <<-EOF
    echo "hello world" > index.html
    nohup busybox httpd -f -p 8080 &
    EOF
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}