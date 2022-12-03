# регион frankfurt
provider "aws" {
    region = "eu-central-1"
}


# привязка vpc к bucket его нужно сначала создать
terraform {
    backend "s3" {
        bucket = "jaysan-jaychiev-project-kgb-terraform-state" # название bucketa
        key    = "dev/servers/terraform.tfstate"   # в бакете сохранит в этой дир id security group
        region = "eu-central-1"          # прописываем регион бакета
    }
}


# берет данные vpc из aws bucketa
data "terraform_remote_state" "network" {
    backend    = "s3"
    config  = {
        bucket = "jaysan-jaychiev-project-kgb-terraform-state" #название бакета
        key    = "dev/network/terraform.tfstate" # название директории
        region = "eu-central-1" # регион
    }
}

# вывод данных aws лбразов
data "aws_ami" "latest_amazon_linux" {
    owners      = ["amazon"]
    most_recent = true
    filter {
        name    = "name"
        values  = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

# instance server
resource "aws_instance" "web_server" {
    ami                    = data.aws_ami.latest_amazon_linux.id #привязываем на полученный образ по id из data
    instance_type          = "t2.micro"
    vpc_security_group_ids = [aws_security_group.webserver.id] # привязываем на наш security group
    subnet_id              = data.terraform_remote_state.network.outputs.public_subnet_ids[0] # выбираем созданную нами первую под сеть
    key_name               = "for_interview"
    user_data              = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform with remote State!" > /var/www/html/index.html
sudo systemctl enable --now httpd
EOF
    tags = {
        Name = "WebServer"
}
}

# create security group this vpc
resource "aws_security_group" "webserver" {
    name   = "WebServer Security Group"
    vpc_id = data.terraform_remote_state.network.outputs.vpc_id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

     ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [data.terraform_remote_state.network.outputs.vpc_cidr]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name  = "web-server-sg"
        Owner = "Jaysan Jaychiev"
    }
}



output "webserver_sg_id" {
    value = aws_security_group.webserver.id
}

output "web_server_public_ip" {
    value = aws_instance.web_server.public_ip
}
