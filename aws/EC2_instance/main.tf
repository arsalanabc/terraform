provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "instance" {
  ami = "ami-0e55e373"
  instance_type = "t1.micro"
  tags {
    Name = 'test-ec2'
  }
}