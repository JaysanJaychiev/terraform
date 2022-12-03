terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

data "aws_availability_zones" "working" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_vpcs" "my_vpcs" {}

data "aws_vpc" "prod_vpc" {
    tags = {
        Name = "prod"
    }
}

output "prod_vpc_id" {
    value = data.aws_vpc.prod_vpc.id
}

output "prod_vpc_cidr" {
    value = data.aws_vpc.prod_vpc.cidr_block
}

output "aws_vpcs" {
    value = data.aws_vpcs.my_vpcs.ids
}


output "data_aws_availability_zones" {
    value = data.aws_availability_zones.working.names
}

output "data_aws_caller_identity" {
    value = data.aws_caller_identity.current.account_id
}

output "data_aws_region_name" {
    value = data.aws_region.current.name
}

output "data_aws_region_description" {
    value = data.aws_region.current.description
}
