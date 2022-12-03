
provider "aws" {
    region = "ca-central-1"
    access_key = "xxxxxxxxxxxxxxxx"
    secret_key = "xxxxxxxxxxxxxxxx"

    assume_role {
        role_arn = "arn:aws:iam::1234567890:role/RemoteAdministrators"
        session_name = "TERRAFORM_SESSION"
    }
}

provider "aws" {
    region = "eu-east-1"
    alias = "USA"
}

provider "aws" {
    region = "eu-central-1"
    alias = "GER"
}
#================================================== AMI
data "aws_ami" "usa_latest_ubuntu" {
    owners      = ["099720109477"]
    most_recent = true
    filter {
        name    = "name"
        values  = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
}
}

#================================================== instance in Canada
resource "aws_instance" "my_default_server" {
    instance_type = "t2.micro"
    ami           = data.aws_ami.usa_latest_ubuntu
    tags = {
        Name = "Default Server"
    }
}

#================================================== instance in USA
resource "aws_instance" "my_usa_server" {
    provider = aws.USA
    instance_type = "t2.micro"
    ami           = data.aws_ami.usa_latest_ubuntu.id
    tags = {
        Name = "USA Server"
    }
}

#================================================== instance in German
resource "aws_instance" "my_ger_server" {
    provider      = aws.GER
    instance_type = "t2.micro"
    ami           = data.aws_ami.usa_latest_ubuntu.id
    tags = {
        Name = "GERMANY Server"
    }
}

