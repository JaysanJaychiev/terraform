terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

data "aws_ami" "latest_amazon_linux" {
    owners = ["amazon"]
    most_recent = true
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}


data "aws_ami" "latest_ubuntu" {
    owners = ["099720109477"]
    most_recent = true
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    }
}

data "aws_ami" "latest_windows_2016" {
    owners = ["amazon"]
    most_recent = true
    filter {
        name = "name"
        values = ["Windows_Server-2016-English-Full-Base-*"]
    }
}

output "latest_windows_2016_ami_id" {
    value = data.aws_ami.latest_windows_2016.id
}

output "latest_windows_2016_ami_name" {
    value = data.aws_ami.latest_windows_2016.name
}

output "latest_amazon_linux_ami_id" {
    value = data.aws_ami.latest_amazon_linux.id
}

output "latest_amazon_linux_ami_name" {
    value = data.aws_ami.latest_amazon_linux.name
}

output "latest_ubuntu_ami_id" {
    value = data.aws_ami.latest_ubuntu.id
}

output "latest_ubuntu_ami_name" {
    value = data.aws_ami.latest_ubuntu.name
}