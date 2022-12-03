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
  region = var.region
}

# ami образ amazon linux
data "aws_ami" "latest_amazon_linux" {
    owners = ["amazon"]
    most_recent = true
    filter {
      name = "name"
      values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

# elastic ip
resource "aws_eip" "my_static_ip" {
    instance = aws_instance.my_server.id
    //tags     = var.common-tags
    tags     = merge(var.common_tags, { Name = "${var.common_tags["Environment"]}  Server IP" })

    /*tags = {
        Name        = "Server IP"
        Owner       = "Jaysan Jaychiev"
        Project     = "Phoenix"
        WhitcRegion = var.region
    }
    */
}

# инстанс
resource "aws_instance" "my_server" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.my_server.id]
  monitoring             = var.enable_detailed_monitoring      # по умолчанию мониторинг false

  tags = merge(var.common_tags, { Name = "${var.common_tags["Environment"]}  Server Build by Terraform" })
  /*tags = {
    Name    = "Server Build by Terraform"
    Owner   = "Jaysan Jaychiev"
    Project = "Pheonix"
  }
  */
}

# security group
resource "aws_security_group" "my_server" {
  name = "My Security Group"

  dynamic "ingress" {
    for_each = var.allow_ports      #цикл входящих портов ingress
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
    
    tags = merge(var.common_tags, { Name = "${var.common_tags["Environment"]}  Server Security Group" })
    /*tags = {
      Name    = "Server Security Group"
      Owner   = "Jaysan Jaychiev"
      Project = "Pheonix"
    }
    */
  }