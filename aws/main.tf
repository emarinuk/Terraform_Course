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

data "aws_ami" "latest_amazon_linux2" {
  owners = ["amazon"]
  most_recent = true
  filter {
    name = "name"
    values = ["amzn2-ami-kernel-*-x86_64-gp2"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_default_security_group" "default_security_group" {
  vpc_id = aws_vpc.my_vpc.id
#  ingress {
#    from_port = 22
#    protocol  = "tcp"
#    to_port   = 22
#    #cidr_blocks = ["0.0.0.0/0"]
#    cidr_blocks = [var.my_public_ip]
#  }
#  ingress {
#    from_port = 80
#    protocol  = "tcp"
#    to_port   = 80
#    cidr_blocks = ["0.0.0.0/0"]
#  }
  dynamic "ingress" {
    for_each = var.ingress_ports
      content {
        from_port = ingress.value
        protocol  = "tcp"
        to_port   = ingress.value
        cidr_blocks = ["0.0.0.0/0"]
      }
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

#resource "aws_instance" "my_vm" {
#  ami = data.aws_ami.latest_amazon_linux2.id
#  instance_type = "t2.micro"
#  subnet_id = aws_subnet.my_subnet.id
#  vpc_security_group_ids = [aws_default_security_group.default_security_group.id]
#  associate_public_ip_address = true
#  key_name = "production_ssh_key"
#  count = 3 # how many?
#  tags = {
#    "Name" = "My Machine"
#  }
#}

variable "usernames" {
  type = list(string)
  default = ["demo-user", "emarin"]
}

resource "aws_iam_user" "test" {
  for_each = toset(var.usernames)
    name = each.key
}

#resource "aws_iam_user" "test" {
#  name = "${element(var.usernames, count.index)}"
#  name = element(var.usernames, count.index)
#  path = "/system/"
#  count = length(var.usernames)
#}

resource "aws_instance" "test-server" {
  ami="ami-06672d07f62285d1d"
  instance_type = "t2.micro"
  count = var.istest == true ? 1 : 0
}

resource "aws_instance" "prod-server" {
  ami="ami-06672d07f62285d1d"
  instance_type = "t2.large"
  count = var.istest == true ? 0 : 1
}