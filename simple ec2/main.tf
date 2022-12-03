terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "amazon-linux" {
  ami           = "ami-070b208e993b59cea"
  instance_type = "t2.micro"

  tags = {
    Name = "test-ec2"
  }
}
