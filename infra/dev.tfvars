aws_region  = "eu-west-2"
az_a        = "eu-west-2a"
az_b        = "eu-west-2b"
environment = "dev"
vpc_cidr    = "10.0.0.0/16"

container_name      = "threatmod-app-container-serverless"
container_image     = "891377356090.dkr.ecr.eu-west-2.amazonaws.com/ecs-threat-composer-app:v2"
container_image_tag = "v2"

ECR_REPOSITORY = "ecs-threat-composer-app"

domain_name               = "threatmodapp.com"
subject_alternative_names = ["tm.threatmodapp.com"]
app_subdomain             = "tm"