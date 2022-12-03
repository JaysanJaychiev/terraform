provider "aws" {
    region = "eu-central-1"
}

# data привязка с существующим S3 бакетом чтобы брать из него данные
data "terraform_remote_state" "global" {
    backend = "s3"
    config = {
        bucket = "jaysan-jaychiev-project-terraform-state"
        key    = "globalvars/terraform.tfstate"
        region = "eu-central-1"
    }
}

# берет output с S3 бакета и переводит их в локальную переменную
locals {
    company_name = data.terraform_remote_state.global.outputs.company_name
    owner        = data.terraform_remote_state.global.outputs.owner
    common_tags  = data.terraform_remote_state.global.outputs.tags
}

#===================== создание первой сети vpc1
resource "aws_vpc" "vpc1" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name    = "Stack1-VPC1"
        Company = local.company_name
        Owner   = local.owner
    }
}

# ======================  создание воторой сети vpc2
resource "aws_vpc" "vpc2" {
    cidr_block = "10.0.0.0/16"
    tags       = merge(local.common_tags, { Name = "Stack2-VPC2" }) #merge добавляет теги multiple
} 


