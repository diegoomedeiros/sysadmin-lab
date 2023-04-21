# VPC
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
resource "aws_vpc" "lab-vpc" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = "true"
  tags = {
    env = var.env
  }
}
# Subnet Publica
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "lab-subnet-1" {
  vpc_id                  = aws_vpc.lab-vpc.id // Referencing the id of the VPC from abouve code block
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = "true" // Makes this a public subnet
  tags = {
    env = var.env
  }
}
# Internet Gateway
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "lab-gw" {
  vpc_id = aws_vpc.lab-vpc.id
  tags = {
    env = var.env
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
  }
}
# Route table e public subnets
#  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "lab-rt-public-subnet-1" {
  subnet_id      = aws_subnet.lab-subnet-1.id
  route_table_id = aws_route_table.lab-public-rt.id
}
