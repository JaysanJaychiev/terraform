terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

resource "aws_default_subnet" "default_az1" {
    availability_zone = "ca-central-1"

    tags = {
        Name = "Default subnet for ca-central-1"
    }
}