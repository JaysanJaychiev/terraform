# terraform init
# terraform import aws_instance.jays_test i-0f0036c94b4da567f
# terraform import aws_security_group_.bastion_test_jays sg-id
# Этот код подключается уже к созданному инстансу занчения нужно изменить

provider "aws" {       # Указывает то что используется амазон cloud
  region = "eu-central-1"  # Франкфурт
}

resource "aws_instance" "jays_test" {
    ami = "ami-076309742d466ad69"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["sg-0878d8cdd706e7f64"]
    key_name = "for_interview"
    tags = {
        Name = "Nomad programmer"
        Owner = "Jaysan Jaychiev"
    }
}
