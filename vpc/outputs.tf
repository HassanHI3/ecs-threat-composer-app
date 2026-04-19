output "vpc_id" {
  value = aws_vpc.ecs_threat_composer_vpc.id
}

output "vpc_arn" {
  value = aws_vpc.ecs_threat_composer_vpc.arn
}

output "vpc_ipv6_cidr_block" {
  value = aws_vpc.ecs_threat_composer_vpc.ipv6_cidr_block
}

output "public_subnet_ids" {
  value = [
    aws_subnet.ecs_public_subnet_a.id,
    aws_subnet.ecs_public_subnet_b.id
  ]
}

output "private_subnet_ids" {
  value = [
    aws_subnet.ecs_private_subnet_a.id,
    aws_subnet.ecs_private_subnet_b.id
  ]
}

output "public_subnet_a_id" {
  value = aws_subnet.ecs_public_subnet_a.id
}

output "public_subnet_b_id" {
  value = aws_subnet.ecs_public_subnet_b.id
}

output "private_subnet_a_id" {
  value = aws_subnet.ecs_private_subnet_a.id
}

output "private_subnet_b_id" {
  value = aws_subnet.ecs_private_subnet_b.id
}