variable "region" {
  description = "Please enter AWS Region to deploy Server"
  type        = string
  default     = "ca-central-1"
}

variable "instance_type" {
    description = "Enter Instance Type"
    type        = string
    default     = "t2.micro"
}

variable "allow_ports" {
    description = "List of ports to open for server"
    type        = list
    default = ["80", "443", "22", "8080"]
}

variable "enable_detailed_monitoring" {
  type    = bool
  default = false
}

# переменная для elastic ip
 variable "common_tags" {
  description = "Common Tags tp apply to all resources"
  type        = map
  default = {
    Owner       = "Jaysanbek Jaychiev"
    Projects    = "Pheonix"
    CostCenter  = "12345"
    Environment = "development"
  }
 }