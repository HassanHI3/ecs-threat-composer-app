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
    Name        = "public-subnet-eu-west-2a"
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
    Name        = "public-subnet-eu-west-2b"
    Environment = var.environment
  }
}

resource "aws_subnet" "ecs_private_subnet_a" {
  vpc_id            = aws_vpc.ecs_threat_composer_vpc.id
  cidr_block        = "10.0.3.0/24"
  ipv6_cidr_block   = cidrsubnet(aws_vpc.ecs_threat_composer_vpc.ipv6_cidr_block, 8, 2)
  availability_zone = var.az_a

  tags = {
    Name        = "private-subnet-eu-west-2a"
    Environment = var.environment
  }
}

resource "aws_subnet" "ecs_private_subnet_b" {
  vpc_id            = aws_vpc.ecs_threat_composer_vpc.id
  cidr_block        = "10.0.4.0/24"
  ipv6_cidr_block   = cidrsubnet(aws_vpc.ecs_threat_composer_vpc.ipv6_cidr_block, 8, 3)
  availability_zone = var.az_b

  tags = {
    Name        = "private-subnet-eu-west-2b"
    Environment = var.environment
  }
}

resource "aws_egress_only_internet_gateway" "ecs_threat_composer_egress_igw" {
  vpc_id = aws_vpc.ecs_threat_composer_vpc.id # use route table to route ipv6 traffic + vpc need to have ipv6 cidr block assigned

  tags = {
    Name        = "ecs-threat-composer-vpc"
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

resource "aws_eip" "nat_eip_eu_west_2a" {
  domain = "vpc"
}

resource "aws_eip" "nat_eip_eu_west_2b" {
  domain = "vpc"
}

resource "aws_nat_gateway" "ecs_threat_composer_nat_gateway_public_a" {
  # vpc_id = aws_vpc.ecs_threat_composer_vpc.id
  # availability_mode = "regional"
  # using zonal NAT gateway but could use regional and it would be more cost effective but less resilient.
  subnet_id     = aws_subnet.ecs_public_subnet_a.id
  allocation_id = aws_eip.nat_eip_eu_west_2a.id

  tags = {
    Name        = "ecs-threat-composer-NAT-GW-eu-west-2a"
    Environment = var.environment
  }
  depends_on = [aws_internet_gateway.ecs_threat_composer_igw]
}

resource "aws_nat_gateway" "ecs_threat_composer_nat_gateway_public_b" {
  # vpc_id = aws_vpc.ecs_threat_composer_vpc.id
  # availability_mode = "regional"
  # using zonal NAT gateway but could use regional and it would be more cost effective but less resilient.
  subnet_id     = aws_subnet.ecs_public_subnet_b.id
  allocation_id = aws_eip.nat_eip_eu_west_2b.id

  tags = {
    Name        = "ecs-threat-composer-NAT-GW-eu-west-2b"
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
    Name = "public-route-table"
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
    Name = "private-route-table-subnet-a"
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
    Name = "private-route-table-subnet-b"
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

resource "aws_security_group" "ecs_threat_composer_tasks_sg" {
  vpc_id = aws_vpc.ecs_threat_composer_vpc.id

  ingress {
    from_port       = 3003
    to_port         = 3003
    protocol        = "tcp"
    security_groups = [aws_security_group.threatmod_application_load_balancer_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ECS-tasks-security-group"
  }
}

resource "aws_lb" "threatmod_application_load_balancer" {
  name               = "threatmod-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.threatmod_application_load_balancer_sg.id]
  subnets            = [aws_subnet.ecs_public_subnet_a.id, aws_subnet.ecs_public_subnet_b.id]

  enable_deletion_protection = false
  #change to true for production environments

  tags = {
    Name        = "threatmod-application-load-balancer-main"
    Environment = var.environment
  }
}

resource "aws_security_group" "threatmod_application_load_balancer_sg" {
  name_prefix = "alb-"
  vpc_id      = aws_vpc.ecs_threat_composer_vpc.id
  description = "Security group for the Application Load Balancer"
  # ALB security group - all external traffic has to come through here

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP from anywhere"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS from anywhere"
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    ipv6_cidr_blocks = ["::/0"]
    description      = "HTTP from anywhere (IPv6)"
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    ipv6_cidr_blocks = ["::/0"]
    description      = "HTTPS from anywhere (IPv6)"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "threatmod-application-load-balancer-sg"
  }
}

resource "aws_lb_target_group" "threatmod_target_group" {
  name        = "threatmod-target-group"
  port        = 3003
  protocol    = "HTTP"
  vpc_id      = aws_vpc.ecs_threat_composer_vpc.id
  target_type = "ip"
  # Required for Fargate
  # similar to ecs tasks and listens on the same port.

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "threatmod-target-group"
    Environment = var.environment
  }
}

resource "aws_lb_listener" "threatmod_alb_listener_for_target_group" {
  load_balancer_arn = aws_lb.threatmod_application_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.threatmod_target_group.arn
  }
  tags = {
    Name = "threatmod-alb-listener"
  }
}

# resource "aws_lb_listener" "threatmod_alb_listener_for_redirect_http_to_https" {
#   load_balancer_arn = aws_lb.threatmod_application_load_balancer.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type = "redirect"

#     redirect {
#       port        = "443"
#       protocol    = "HTTPS"
#       status_code = "HTTP_301"
#       # this means that it permanently redirects the http to https and browser will cache it for next time
#     }
#   }

#   tags = {
#     Name = "threatmod-alb-listener-redirect-to-https"
#   }
# }


resource "aws_ecr_repository" "ecs_threat_composer_app" {
  name                 = var.ECR_REPOSITORY
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
# resource "aws_secretsmanager_secret" "my_secret" {
#   name = "my-app-credentials"
# }

# resource "aws_secretsmanager_secret_version" "my_secret_version" {
#   secret_id = aws_secretsmanager_secret.my_secret.id
#   secret_string = jsonencode({
#     ECR_REGISTRY   = var.ECR_REGISTRY
#     ECR_REPOSITORY = var.ECR_REPOSITORY
#     IMAGE_URI      = "${var.ECR_REGISTRY}/${var.ECR_REPOSITORY}:${var.container_image_tag}"
#   })
# }
resource "aws_ecs_cluster" "threatmod_cluster" {
  name = "threatmod-cluster-main"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name        = "threatmod-cluster-main"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "threatmod_task_log_group" {
  name              = "/ecs/threatmod-task"
  retention_in_days = 30

  tags = {
    Name        = "threatmod-task-log-group"
    Environment = var.environment
  }
}
resource "aws_appautoscaling_target" "ecs_service_scaling" {
  max_capacity = 4
  min_capacity = 2

  resource_id        = "service/${aws_ecs_cluster.threatmod_cluster.name}/${aws_ecs_service.threatmod_cluster_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_cpu_policy" {
  name        = "ecs-cpu-target-tracking"
  policy_type = "TargetTrackingScaling"

  resource_id        = aws_appautoscaling_target.ecs_service_scaling.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_service_scaling.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_service_scaling.service_namespace
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 70 # keep CPU around 70% but if it reaches above then scaling will be triggered
    scale_in_cooldown  = 120
    scale_out_cooldown = 60
  }
}
resource "aws_ecs_task_definition" "threatmod_app_task" {
  family                   = "threatmod-app-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"
  task_role_arn            = var.task_role_arn
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "threatmod-app-container-serverless"
      image     = var.container_image
      essential = true

      portMappings = [
        {
          containerPort = 3003
          hostPort      = 3003
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/threatmod-task"
          awslogs-region        = "eu-west-2"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}
resource "aws_ecs_service" "threatmod_cluster_service" {
  name             = "threatmod-cluster-service"
  cluster          = aws_ecs_cluster.threatmod_cluster.id
  task_definition  = aws_ecs_task_definition.threatmod_app_task.arn
  desired_count    = 2
  launch_type      = "FARGATE"
  platform_version = "LATEST"
  # Specific version = only needed in production

  tags = {
    Name        = "threatmod-cluster-service"
    Environment = var.environment
  }

  deployment_controller {
    type = "ECS" # This means "Rolling Update"
  }

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  # 100% of desired tasks running
  # Allow up to 200% during deployment (for rolling updates)

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  enable_execute_command = true

  force_new_deployment = true

  depends_on = [
    aws_lb_listener.threatmod_alb_listener_for_target_group,
    # aws_lb_listener.threatmod_alb_listener_for_redirect_http_to_https
  ]

  network_configuration {
    subnets          = [aws_subnet.ecs_private_subnet_a.id, aws_subnet.ecs_private_subnet_b.id]
    security_groups  = [aws_security_group.ecs_threat_composer_tasks_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.threatmod_target_group.arn
    container_name   = "threatmod-app-container-serverless"
    container_port   = 3003
  }
}
resource "aws_route53_zone" "main" {
  name = "threatmodapp.com"
}
resource "aws_route53_record" "threatmod_app" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "tm.threatmodapp.com"
  type    = "A"
  alias {
    name                   = aws_lb.threatmod_application_load_balancer.dns_name
    zone_id                = aws_lb.threatmod_application_load_balancer.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "threatmodapp.com"
  type    = "A"

  alias {
    name                   = aws_lb.threatmod_application_load_balancer.dns_name
    zone_id                = aws_lb.threatmod_application_load_balancer.zone_id
    evaluate_target_health = true
  }
}