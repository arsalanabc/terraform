provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "test" {
  ami = "ami-ee0b0688"
  instance_type = "t1.micro"
  tags {
    Name = "test-ec2"
  }
}