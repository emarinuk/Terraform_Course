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
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "My VPC"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "eu-west-2b"
  tags = {
    "Name" = "My Subnet"
  }
}

resource "aws_internet_gateway" "my_web_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    "Name" = "My VPC IGW"
  }
}

resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_web_igw.id
  }
  tags = {
    "Name" = "My IGW"
  }
}