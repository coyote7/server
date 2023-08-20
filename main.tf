#creating a webserver
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.16"
    }
  }
}

provider "aws" {
  region  = "us-east-2"
  profile = "ronte"
}
#create the ec2 instance
resource "aws_instance" "webserver" {
  ami                         = "ami-0ddf7dfd13a83d8c8"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.webserver-sg.id]
  user_data                   = <<-EOF
             #!/bin/bash
             echo "Welcome to My Apache Web Server">/var/www/html/index.html
             apt-get update
             apt-get install -y apache2
             service apache2 start
            EOF
  user_data_replace_on_change = true
  tags = {
    Name = "Webserver"
  }

}

resource "aws_security_group" "webserver-sg" {
  name = "webserver-sg"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}