

provider "aws" {
    region = "eu-central-1"
}

#переменная env = prod
variable "env" {
    default = "staging"
}

variable "prod_owner" {
    default = "Jaysan Jaychiev"
}

variable "noprod_owner" {
    default = "Dyadya Vasya"
}

#map карта
variable "ec2_size" {
    default = {
        "prod" = "t3.micro"
        "dev" = "t2.micro"
        "staging" = "t2.small"
    }
}

#security group variable
variable "allow_port_list" {
    default = {
        "prod" = ["80", "443"]
        "dev" = ["80", "443", "8080", "22"]
    }
}

# вебсервер инстанс
resource "aws_instance" "my_webserver1" {
    ami           = "ami-03a71cec707bfc3d7"
    # условия if else
    instance_type = var.env == "staging" ? var.ec2_size["prod"] : var.ex2_size["dev"]

    tags = {
        Name = "${var.env}-server"
        Owner = var.env == "staging" ? var.prod_owner : var.noprod_owner
    }
}


# вебсервер инстанс2
resource "aws_instance" "my_webserver2" {
    ami           = "ami-03a71cec707bfc3d7"
    # условия if else
    instance_type = lookup(var.ec2_size, var.env)

    tags = {
        Name = "${var.env}-server"
        Owner = var.env == "prod" ? var.prod_owner : var.noprod_owner
    }
}


# бастион инстанс
resource "aws_instance" "my_dev_bastion" {
    count         = var.env == "dev" ? 1 : 0
    ami           = "ami-03a71cec707bfc3d7"
    # условия if else
    instance_type = "t2.micro" 

    tags = {
        Name = "Bastion Server for Dev server"
    }
}


#firewall
resource "aws_security_group" "my_webserver" {
  name = "Dynamic Security Group"

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

  tags = {
    Name  = "Dynamic SecurityGroup"
    Owner = "Denis Astahov"
  }
}