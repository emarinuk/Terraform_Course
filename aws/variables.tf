variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
  description = "CIDR Block for the VPC"
  type = string
}

variable "web_subnet" {
  default = "10.0.10.0/24"
  description = "Web Subnet"
  type = string
}

variable "subnet_zone" {
  default = "eu-west-2b"
  description = "AZ for subnet"
  type = string
}

variable "main_vpc_name" {
  default = "My VPC"
  description = "Name of the VPC"
  type = string
}

variable "aws_access_key" {
  description = "AWS Access Key"
  type = string
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type = string
}

variable "my_public_ip" {
  description = "My Public IP"
  type = string
}

variable "ingress_ports" {
  description = "List if ingress ports"
  type = list(number)
  default = [22, 80, 110, 143, 443, 993, 8080]
}
