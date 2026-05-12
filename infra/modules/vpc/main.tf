resource "aws_vpc" "ecs_threat_composer_vpc" {
  cidr_block                       = var.vpc_cidr
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name        = "ecs-threat-composer-vpc"
    Environment = var.environment
  }
}

resource "aws_subnet" "ecs_public_subnet_a" {
  vpc_id                  = aws_vpc.ecs_threat_composer_vpc.id
  cidr_block              = "10.0.1.0/24"
  ipv6_cidr_block         = cidrsubnet(aws_vpc.ecs_threat_composer_vpc.ipv6_cidr_block, 8, 0)
  availability_zone       = var.az_a
  map_public_ip_on_launch = true

  tags = {
    Name        = "public-subnet-${var.az_a}"
    Environment = var.environment
  }
}

resource "aws_subnet" "ecs_public_subnet_b" {
  vpc_id                  = aws_vpc.ecs_threat_composer_vpc.id
  cidr_block              = "10.0.2.0/24"
  ipv6_cidr_block         = cidrsubnet(aws_vpc.ecs_threat_composer_vpc.ipv6_cidr_block, 8, 1)
  availability_zone       = var.az_b
  map_public_ip_on_launch = true

  tags = {
    Name        = "public-subnet-${var.az_b}"
    Environment = var.environment
  }
}

resource "aws_subnet" "ecs_private_subnet_a" {
  vpc_id            = aws_vpc.ecs_threat_composer_vpc.id
  cidr_block        = "10.0.3.0/24"
  ipv6_cidr_block   = cidrsubnet(aws_vpc.ecs_threat_composer_vpc.ipv6_cidr_block, 8, 2)
  availability_zone = var.az_a

  tags = {
    Name        = "private-subnet-${var.az_a}"
    Environment = var.environment
  }
}

resource "aws_subnet" "ecs_private_subnet_b" {
  vpc_id            = aws_vpc.ecs_threat_composer_vpc.id
  cidr_block        = "10.0.4.0/24"
  ipv6_cidr_block   = cidrsubnet(aws_vpc.ecs_threat_composer_vpc.ipv6_cidr_block, 8, 3)
  availability_zone = var.az_b

  tags = {
    Name        = "private-subnet-${var.az_b}"
    Environment = var.environment
  }
}

resource "aws_egress_only_internet_gateway" "ecs_threat_composer_egress_igw" {
  vpc_id = aws_vpc.ecs_threat_composer_vpc.id

  tags = {
    Name        = "ecs-threat-composer-egress-igw"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "ecs_threat_composer_igw" {
  vpc_id = aws_vpc.ecs_threat_composer_vpc.id

  tags = {
    Name        = "ecs-threat-composer-igw"
    Environment = var.environment
  }
}

resource "aws_eip" "nat_eip_a" {
  domain = "vpc"
  tags = {
    Name        = "nat-eip-${var.az_a}"
    Environment = var.environment
  }
}

resource "aws_eip" "nat_eip_b" {
  domain = "vpc"
  tags = {
    Name        = "nat-eip-${var.az_b}"
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "ecs_threat_composer_nat_gateway_public_a" {
  subnet_id     = aws_subnet.ecs_public_subnet_a.id
  allocation_id = aws_eip.nat_eip_a.id

  tags = {
    Name        = "ecs-threat-composer-NAT-GW-${var.az_a}"
    Environment = var.environment
  }
  depends_on = [aws_internet_gateway.ecs_threat_composer_igw]
}

resource "aws_nat_gateway" "ecs_threat_composer_nat_gateway_public_b" {
  subnet_id     = aws_subnet.ecs_public_subnet_b.id
  allocation_id = aws_eip.nat_eip_b.id

  tags = {
    Name        = "ecs-threat-composer-NAT-GW-${var.az_b}"
    Environment = var.environment
  }
  depends_on = [aws_internet_gateway.ecs_threat_composer_igw]
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.ecs_threat_composer_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs_threat_composer_igw.id
  }

  tags = {
    Name        = "public-route-table"
    Environment = var.environment
  }
}

resource "aws_route_table" "private_route_table_subnet_a" {
  vpc_id = aws_vpc.ecs_threat_composer_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ecs_threat_composer_nat_gateway_public_a.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.ecs_threat_composer_egress_igw.id
  }

  tags = {
    Name        = "private-route-table-subnet-a"
    Environment = var.environment
  }
}

resource "aws_route_table" "private_route_table_subnet_b" {
  vpc_id = aws_vpc.ecs_threat_composer_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ecs_threat_composer_nat_gateway_public_b.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.ecs_threat_composer_egress_igw.id
  }

  tags = {
    Name        = "private-route-table-subnet-b"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "ecs_public_subnet_a" {
  subnet_id      = aws_subnet.ecs_public_subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "ecs_public_subnet_b" {
  subnet_id      = aws_subnet.ecs_public_subnet_b.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "ecs_private_subnet_a" {
  subnet_id      = aws_subnet.ecs_private_subnet_a.id
  route_table_id = aws_route_table.private_route_table_subnet_a.id
}

resource "aws_route_table_association" "ecs_private_subnet_b" {
  subnet_id      = aws_subnet.ecs_private_subnet_b.id
  route_table_id = aws_route_table.private_route_table_subnet_b.id
}