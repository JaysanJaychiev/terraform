provider "aws" {
    region = "eu-central-1"
}

# путь до модуля VPC сети
module "vpc-default" {
    # это расположкемк в нашей директори
    source = "../modules/aws_network"
    
    # также можно указать гитхаб
    # source = "git@hithub.com:adv4000/terraform-modules.git//aws_network"

}

# новая сеть dev
module "vpc-dev" {
    # это расположкемк в нашей директори
    source               = "../modules/aws_network"
    # также можно указать гитхаб
    # source = "git@hithub.com:adv4000/terraform-modules.git//aws_network"
    env                  = "dev"
    vpc_cidr             = "10.100.0.0/16"
    public_subnet_cidrs   = ["10.100.1.0/24", "10.100.2.0/24"]
    private_subnet_cidrs = []
}

# еще одна сеть prod
module "vpc-prod" {
    # это расположкемк в нашей директори
    source               = "../modules/aws_network"
    # также можно указать гитхаб
    # source = "git@hithub.com:adv4000/terraform-modules.git//aws_network"
    env                  = "prod"
    vpc_cidr             = "10.10.0.0/16"
    public_subnet_cidrs  = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
    private_subnet_cidrs = ["10.10.11.0/24", "10.10.22.0/24", "10.10.33.0/24"]
}

# это уже тестовая сеть
module "vpc-stg" {
    # это расположкемк в нашей директори
    source               = "../modules/aws_network"
    # также можно указать гитхаб
    # source = "git@hithub.com:adv4000/terraform-modules.git//aws_network"
    env                  = "stg"
    vpc_cidr             = "10.10.0.0/16"
    public_subnet_cidrs = ["10.10.1.0/24", "10.10.2.0/24"]
    private_subnet_cidrs = ["10.10.11.0/24", "10.10.22.0/24"]
}

# ================================== Outputs

output "prod_public_subnet_ids" {
    value = module.vpc-prod.public_subnet_ids
}

output "prod_private_subnet_ids" {
    value = module.vpc-prod.private_subnet_ids
}

output "dev_public_subnet_ids" {
    value = module.vpc-dev.public_subnet_ids
}

output "dev_private_subnet_ids" {
    value = module.vpc-dev.private_subnet_ids
}