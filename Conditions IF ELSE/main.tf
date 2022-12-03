provider "aws" {
    region = "eu-central-1"
}

#переменная env = prod
variable "env" {
    default = "prod"
}

variable "prod_owner" {
    default = "Jaysan Jaychiev"
}

variable "noprod_owner" {
    default = "Dyadya Vasya"
}

# вебсервер инстанс
resource "aws_instance" "my_webserver" {
    ami           = "ami-03a71cec707bfc3d7"
    # условия if else
    instance_type = var.env == "prod" ? "t2.micro" : "t2.large" 

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