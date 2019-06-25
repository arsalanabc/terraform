provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "test" {
  ami = "ami-ee0b0688"
  instance_type = "t1.micro"
  tags {
    Name = "test-ec2"
  }

  user_data = <<-EOF
    echo "hello world" > index.html
    nohup busybox httpd -fp 8080 &
    EOF
}