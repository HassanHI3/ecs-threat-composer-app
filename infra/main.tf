module "vpc" {
  source = "./modules/vpc"

  vpc_cidr    = var.vpc_cidr
  az_a        = var.az_a
  az_b        = var.az_b
  environment = var.environment
}

module "acm" {
  source = "./modules/acm"

  environment               = var.environment
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  app_subdomain             = var.app_subdomain
  alb_dns_name              = module.alb.alb_dns_name
  cloudflare_zone_id        = var.cloudflare_zone_id
}

module "alb" {
  source = "./modules/alb"

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  certificate_arn   = module.acm.certificate_arn
  container_port    = 3003
  environment       = var.environment
}

module "ecr" {
  source = "./modules/ecr"

  ecr_repository_name = var.ECR_REPOSITORY
  environment         = var.environment
}

module "ecs" {
  source = "./modules/ecs"

  aws_region            = var.aws_region
  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  alb_security_group_id = module.alb.alb_security_group_id
  target_group_arn      = module.alb.target_group_arn

  alb_listener_dependencies = [
    module.alb.https_listener_arn,
    module.alb.http_listener_arn,
  ]

  container_image    = var.container_image
  container_name     = var.container_name
  container_port     = 3003
  task_role_arn      = var.task_role_arn
  execution_role_arn = var.execution_role_arn
}