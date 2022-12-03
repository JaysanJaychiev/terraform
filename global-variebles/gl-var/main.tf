provider "aws" {
    region = "eu-central-1"
}

# terraform связь с существующим S3 бакетом чтобы отправить туда свои данные output
terraform {
    backend "s3" {
        bucket = "jaysan-jaychiev-project-terraform-state"
        key    = "globalvars/terraform.tfstate"
        region = "eu-central-1"
    }
}

# ================================================ Output
output "company_name" {
    value = "ANDESA Soft International"
}

output "owner" {
    value = "Jaysan Jaychiev"
}

output "tags" {
    value = {
        Project    = "USA"
        CostCenter = "R&D"
        Country    = "Frankfurt"
    }
}