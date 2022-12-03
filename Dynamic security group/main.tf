#это конфигурации по умолчанию терраформ
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

# Указывает то что используется провайдер амазон cloud
provider "aws" {       
  region = "eu-central-1"
}

# этот resource ec2
resource "aws_instance" "my_webserver" {
  ami                    = "ami-070b208e993b59cea"  # Amazon Linux AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id] #привязка своего security group
  key_name               = "for_interview"

  user_data              = templatefile("user_data.sh.tpl", {
    f_name = "Aidar",
    l_name = "Darksnet",
    names = ["Orozbak", "Ermek", "Danila", "Dosya", "Dimon", "Nukew", "Jays", "XYZ"]
  })

  tags = {
    Name = "web-server" #instance name
    Owner = "Jaysan Jaychiev"
  }

  depends_on = [aws_instance.my_server_db]
  

#   lifecycle {
#     ignore_changes = ["ami", "user_data"]    #игнорирует изменения
#   }
}

#этот resource security group
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



