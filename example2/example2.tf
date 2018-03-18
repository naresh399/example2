provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "example" {
  ami = "ami-2d39803a"
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, india" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
  tags {
    Name = "terraform-example"
  }
}
resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]

  ingress {
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
