variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default = "eu-west-2"
}

variable "az_a" {
  description = "Primary availability zone"
  type        = string
  default = "eu-west-2a"
}

variable "az_b" {
  description = "Secondary availability zone"
  type        = string
  default = "eu-west-2b"
}

variable "environment" {
  description = "Environment name such as dev, staging, or prod"
  type        = string
  default = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default = "10.0.0.0/16"
}

# variable "certificate_arn" {
#   description = "ACM certificate ARN for the HTTPS listener"
#   type        = string
#   sensitive =  true
# }

variable "container_image" {
  description = "Full container image URI for the ECS task"
  type        = string
  default = "threatmod-app-container-serverless"
}

variable "container_name" {
  description = "Name of the container in the ECS task definition"
  type        = string
  default = "891377356090.dkr.ecr.eu-west-2.amazonaws.com/ecs-threat-composer-app:latest"
}

variable "container_image_tag" {
  description = "The image tag for the container (e.g., 'latest' or 'v1.0')"
  type        = string
}

variable "task_role_arn" {
  description = "IAM role ARN assumed by the running ECS task"
  type        = string
  sensitive = true
}

variable "execution_role_arn" {
  description = "IAM execution role ARN used by ECS to pull images and send logs"
  type        = string
  sensitive = true
}
variable "ECR_REGISTRY" {
  description = "ECR registry URL"
  type        = string
}

variable "ECR_REPOSITORY" {
  description = "ECR repository name"
  type        = string
}