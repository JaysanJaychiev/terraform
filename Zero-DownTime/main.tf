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

# список данных авиабилити зон 
data "aws_availability_zones" "available" {}

# список данных последних амазон линуксов
data "aws_ami" "latest_amazon_linux" {
    owners      = ["amazon"]
    most_recent = true
    filter {
        name    = "name"
        values  = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

# ---------------------------------------------------
# это уже секюрити групп web
resource "aws_security_group" "web" {
  name = "Dynamic Security Group"

  #Динамический файрвол
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
    Name = "Dynamic SecurityGroup"
    Owner = "Jaysan Jaychiev"
  }
}

#*********************************  Auto Scalling автосоздание инстансов при нагрузке
#*********************************  Launch confiiguration тип AMI инстанса
resource "aws_launch_configuration" "web" {
    # name            = "WebServer-Highly-Available-LC"  #статичное имя
    name_prefix     = "WebServer-Highly-Available-LC-"   #динамическое имя генерирет name_prefix c датой
    image_id        = data.aws_ami.latest_amazon_linux.id  #здесь привязываем AMI образ
    instance_type   = "t2.micro"
    security_groups = [aws_security_group.web.id] #здесь привязываем cекюрити груп web
    key_name        = "for_interview"
    user_data       = file("user_data.sh")
    #life цикл при изменении launch configuration сначала создаст потом удалит старую
    lifecycle {
        create_before_destroy = true
    }
}

# ****************************************  Autoscaling group
resource "aws_autoscaling_group" "web" {
    # name                 = "WebServer-Highly-Available-ASG"    #статическое имя
    name                 = "ASG-${aws_launch_configuration.web.name}" #динамическое имя зависет от launch configuration
    launch_configuration = aws_launch_configuration.web.name
    # при создании создаст 2
    min_size             = 2
    # при нагрузке не увелится максимум на 4
    max_size             = 4
    # минимальная привязка к лоад балансеру
    min_elb_capacity     = 2
    health_check_type    = "ELB"
    vpc_zone_identifier  = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
    load_balancers        = [aws_elb.web.name]

    dynamic "tag" {
        # cнизу это цикл for_each значения в контент tag
        for_each   = {
            Name   = "WebServer in ASG"
            Owner  = "Jaysan Jaychiev"
            TAGKEY = "TAGVALUE"
        }
        content {
            key                 = tag.key
            value               = tag.value
            propagate_at_launch = true
        }
    } 

    # life цикл при изменении сначала создает новую AutoScallingGroup потом убивает старую 
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_elb" "web" {
    name                = "WebServer-HA-ELB"
    # авиалиби зону можно указать несколько через точку
    availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
    security_groups     = [aws_security_group.web.id]

    listener {
        lb_port           = 80         # трафик приходящий на лоад балансер по порту 80
        lb_protocol       = "http"
        instance_port     = 80         # трафик приходящий на инстанс тоже порт 80
        instance_protocol = "http"
    }

    health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 3
        target              = "HTTP:80/"
        interval            = 10
    }

    tags = {
        Name = "WebServer-Highly-Availabe-ELB"
    }
}

#выводит subnet по умолчанию 1 авиалибити зоны
resource "aws_default_subnet" "default_az1" {
    availability_zone = data.aws_availability_zones.available.names[0]
}

#выводит subnet по умолчанию 2 авиалибити зоны
resource "aws_default_subnet" "default_az2" {
    availability_zone = data.aws_availability_zones.available.names[1]
}

#----------------------------------
output "web_loadbalancer_url" {
  value = aws_elb.web.dns_name
}