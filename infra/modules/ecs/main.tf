# Security Group
resource "aws_security_group" "ecs_threat_composer_tasks_sg" {
  name_prefix = "ecs-tasks-"
  vpc_id      = var.vpc_id
  description = "Security group for ECS tasks"

  ingress {
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
    description     = "Allow traffic from ALB on container port"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "ECS-tasks-security-group"
    Environment = var.environment
  }
}

# ECS Cluster
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

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "threatmod_task_log_group" {
  name              = "/ecs/threatmod-task"
  retention_in_days = 30

  tags = {
    Name        = "threatmod-task-log-group"
    Environment = var.environment
  }
}

# ECS Task Definition
resource "aws_ecs_task_definition" "threatmod_app_task" {
  family                   = "threatmod-app-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  task_role_arn            = var.task_role_arn
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.container_image
      essential = true

      portMappings = [{
        containerPort = var.container_port
        hostPort      = var.container_port
        protocol      = "tcp"
        appProtocol   = "http"
      }]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.threatmod_task_log_group.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  tags = {
    Name        = "threatmod-app-task"
    Environment = var.environment
  }
}

# ECS Service
resource "aws_ecs_service" "threatmod_cluster_service" {
  name             = "threatmod-cluster-service"
  cluster          = aws_ecs_cluster.threatmod_cluster.id
  task_definition  = aws_ecs_task_definition.threatmod_app_task.arn
  desired_count    = var.desired_count
  platform_version = "LATEST"
  launch_type      = "FARGATE"

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_controller {
    type = "ECS"
  }

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  enable_execute_command = true
  force_new_deployment   = true

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs_threat_composer_tasks_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  depends_on = [var.alb_listener_dependencies]

  tags = {
    Name        = "threatmod-cluster-service"
    Environment = var.environment
  }
}

# Auto Scaling Target
resource "aws_appautoscaling_target" "ecs_service_scaling" {
  max_capacity       = var.autoscaling_max_capacity
  min_capacity       = var.autoscaling_min_capacity
  resource_id        = "service/${aws_ecs_cluster.threatmod_cluster.name}/${aws_ecs_service.threatmod_cluster_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Auto Scaling Policy
resource "aws_appautoscaling_policy" "ecs_cpu_policy" {
  name               = "ecs-cpu-target-tracking"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_service_scaling.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_service_scaling.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_service_scaling.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 70
    scale_in_cooldown  = 120
    scale_out_cooldown = 60
  }
}