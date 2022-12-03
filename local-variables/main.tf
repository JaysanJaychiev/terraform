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


data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

locals {
    # локальная переменная с полным названием
    full_project_name = "${var.environment}-${var.project_name}" 
    project_owner = "${var.owner} owner of ${var.project_name}"
}

locals {
  country  = "Canada"
  city     = "Deadmonton"
  az_list  = join(",", data.aws_availability_zones.available.names)
  region   = data.aws_region.current.description
  location = "In ${local.region} there are AZ: ${local.az_list}"
}

resource "aws_eip" "my_static_ip" {
    tags = {
        Name       = "Static IP"
        Owner      = var.owner
        Project    = local.full_project_name
        proj_owner = local.project_owner
        city       = local.city
        region_azs = local.az_list
        location   = local.location
    }
}