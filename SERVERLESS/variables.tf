variable "api_gateway_custom_domain" {
    description = "Domain Name for API Gateway to use"
    default = "astahov.net"
}

variable "api_gateway_custom_domain_certificate_arn" {
    description = "Certificate ARN which cover [api_gateway_custom_domain"
    default     = "arn:aws:acm:us-west-2:061302979075:certificate/50e99d8e-872d-449b-a282-cb7cf6852422"
}

variable "tags" {
    description = "Tags to apply to Resources"
    default = {
        Owner   = "Denis Astahov"
        Company = "ADV-IT"
    }
}

variable "name" {
    description = "Name to use for Resources"
    default     = "Serverless-APIGateway-TF"
}