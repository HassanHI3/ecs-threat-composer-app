resource "aws_vpc" "ecs_threat_composer_vpc" {
  cidr_block                       = var.vpc_cidr
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name        = var.vpc_name
    Environment = var.environment
  }
}

resource "aws_subnet" "ecs_public_subnet_a" {
  vpc_id                  = aws_vpc.ecs_threat_composer_vpc.id
  cidr_block              = var.public_subnet_a_cidr
  ipv6_cidr_block         = cidrsubnet(aws_vpc.ecs_threat_composer_vpc.ipv6_cidr_block, 8, 0)
  availability_zone       = var.az_a
  map_public_ip_on_launch = true

  tags = {
    Name        = var.public_subnet_a_name
    Environment = var.environment
  }
}

resource "aws_subnet" "ecs_public_subnet_b" {
  vpc_id                  = aws_vpc.ecs_threat_composer_vpc.id
  cidr_block              = var.public_subnet_b_cidr
  ipv6_cidr_block         = cidrsubnet(aws_vpc.ecs_threat_composer_vpc.ipv6_cidr_block, 8, 1)
  availability_zone       = var.az_b
  map_public_ip_on_launch = true

  tags = {
    Name        = var.public_subnet_b_name
    Environment = var.environment
  }
}

resource "aws_subnet" "ecs_private_subnet_a" {
  vpc_id            = aws_vpc.ecs_threat_composer_vpc.id
  cidr_block        = var.private_subnet_a_cidr
  ipv6_cidr_block   = cidrsubnet(aws_vpc.ecs_threat_composer_vpc.ipv6_cidr_block, 8, 2)
  availability_zone = var.az_a

  tags = {
    Name        = var.private_subnet_a_name
    Environment = var.environment
  }
}

resource "aws_subnet" "ecs_private_subnet_b" {
  vpc_id            = aws_vpc.ecs_threat_composer_vpc.id
  cidr_block        = var.private_subnet_b_cidr
  ipv6_cidr_block   = cidrsubnet(aws_vpc.ecs_threat_composer_vpc.ipv6_cidr_block, 8, 3)
  availability_zone = var.az_b

  tags = {
    Name        = var.private_subnet_b_name
    Environment = var.environment
  }
}