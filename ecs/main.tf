resource "aws_security_group" "ecs_tasks_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port       = 3003
    to_port         = 3003
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "ecs-tasks-security-group"
    Environment = var.environment
  }
}

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
    Environment = var.environment
  }
}

resource "aws_ecs_service" "threatmod_cluster_service" {
  name             = "threatmod-cluster-service"
  cluster          = aws_ecs_cluster.threatmod_cluster.id
  task_definition  = aws_ecs_task_definition.threatmod_app_task.arn
  desired_count    = 2
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  tags = {
    Name        = "threatmod-cluster-service"
    Environment = var.environment
  }

  deployment_controller {
    type = "ECS"
  }

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  enable_execute_command = true
  force_new_deployment   = true

  depends_on = [var.listener_dependency]

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs_tasks_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "threatmod-app-container-serverless"
    container_port   = 3003
  }
}

resource "aws_appautoscaling_target" "ecs_service_scaling" {
  max_capacity       = 4
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.threatmod_cluster.name}/${aws_ecs_service.threatmod_cluster_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

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