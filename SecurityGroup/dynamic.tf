terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {       # Указывает то что используется амазон cloud
  region = "eu-central-1"
}

resource "aws_instance" "my_webserver" {
  ami                    = "ami-070b208e993b59cea"  # Amazon Linux AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id] #привязка своего security group
  key_name               = "for_interview"
  tags = {
    Name = "web-server" #instance name
    Owner = "Jaysan Jaychiev"
  }
  
}

resource "aws_security_group" "my_webserver" {
  name              = "Dynamic Security Group"

  dynamic "ingress" {  #inbound dynamic 
    for_each        = ["80", "443", "22"]
    content {
        from_port   = ingress.value
        to_port     = ingress.value
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {       #outbound
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}




