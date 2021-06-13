resource "aws_vpc" "grad_ctf" {
  cidr_block = var.cidr_block.vpc
  enable_dns_hostnames = true
}

resource "aws_subnet" "grad_ctf_public_a" {
  vpc_id            = aws_vpc.grad_ctf.id
  availability_zone = var.availability_zone
  cidr_block        = var.cidr_block.public_subnet_primary
}

resource "aws_subnet" "grad_ctf_public_b" {
  vpc_id            = aws_vpc.grad_ctf.id
  availability_zone = var.availability_zone_secondary
  cidr_block        = var.cidr_block.public_subnet_secondary
}

resource "aws_subnet" "grad_ctf_private" {
  vpc_id            = aws_vpc.grad_ctf.id
  availability_zone = var.availability_zone
  cidr_block        = var.cidr_block.private_subnet
}

resource "aws_internet_gateway" "grad_ctf" {
  vpc_id = aws_vpc.grad_ctf.id
}

resource "aws_route" "egress_traffic" {
  route_table_id         = aws_vpc.grad_ctf.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.grad_ctf.id
}