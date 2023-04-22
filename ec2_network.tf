# VPC
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
resource "aws_vpc" "lab-vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = "true"
  tags = {
    env = var.env
    Name = "lab-vpc"
  }
}
# Subnet Publica
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "lab-subnet-1" {
  vpc_id                  = aws_vpc.lab-vpc.id 
  cidr_block              = var.subrede_cidr_block
  map_public_ip_on_launch = "true" 
  tags = {
    env = var.env
    Name = "lab-subnet"
  }
}
# Internet Gateway
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "lab-gw" {
  vpc_id = aws_vpc.lab-vpc.id
  tags = {
    env = var.env
    Name = "lab-gw"
  }
}
# Route table 
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "lab-public-rt" {
  vpc_id = aws_vpc.lab-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab-gw.id
  }
  tags = {
    env = var.env
    Name = "lab-rt"
  }
}
# Route table e public subnets
#  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "lab-rt-public-subnet-1" {
  subnet_id      = aws_subnet.lab-subnet-1.id
  route_table_id = aws_route_table.lab-public-rt.id
}
