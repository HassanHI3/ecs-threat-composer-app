environment = "dev"
aws_region  = "eu-west-2"
az_a        = "eu-west-2a"
az_b        = "eu-west-2b"

vpc_cidr        = "10.0.0.0/16"
container_image = "891377356090.dkr.ecr.eu-west-2.amazonaws.com/ecs-threat-composer-app:v2"
certificate_arn = "arn:aws:acm:eu-west-2:891377356090:certificate/2faefa9e-2fdd-483f-ab3c-44e21e4f9842"

task_role_arn      = "arn:aws:iam::891377356090:role/ECS-threatmod-task-role"
execution_role_arn = "arn:aws:iam::891377356090:role/ecsTaskExecutionRole"

