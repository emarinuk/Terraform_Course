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
