terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.31.0"
    }
  }
}

provider "aws" {
  region     = "eu-west-2" # Configuration options
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "Name" = "Production ${var.main_vpc_name}"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.web_subnet
  availability_zone = var.subnet_zone
  tags = {
    "Name" = "My Subnet"
  }
}

resource "aws_internet_gateway" "my_web_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    "Name" = "${var.main_vpc_name} IGW"
  }
}
resource "aws_default_route_table" "vpc_default_rt" {
  default_route_table_id = aws_vpc.my_vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_web_igw.id
  }
  tags = {
    "Name" = "My Default RT"
  }
}

resource "aws_security_group" "default_security_group" {
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    #cidr_blocks = ["0.0.0.0/0"]
    cidr_blocks = [var.my_public_ip]
  }
  ingress {
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol  = "-1" # any protocol
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "Security Group"
  }
}