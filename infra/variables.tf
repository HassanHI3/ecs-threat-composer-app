variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
}

variable "az_a" {
  description = "Primary availability zone"
  type        = string
}

variable "az_b" {
  description = "Secondary availability zone"
  type        = string
}

variable "environment" {
  description = "Environment name such as dev, staging, or prod"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "certificate_arn" {
  description = "ACM certificate ARN for the HTTPS listener"
  type        = string
}

variable "container_image" {
  description = "Full container image URI for the ECS task"
  type        = string
}

variable "task_role_arn" {
  description = "IAM role ARN assumed by the running ECS task"
  type        = string
}

variable "execution_role_arn" {
  description = "IAM execution role ARN used by ECS to pull images and send logs"
  type        = string
}