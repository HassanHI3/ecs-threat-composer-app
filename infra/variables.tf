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

variable "container_name" {
  description = "Name of the container in the ECS task definition"
  type        = string
}

variable "container_image_tag" {
  description = "The image tag for the container (e.g., 'latest' or 'v1.0')"
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

variable "AWS_ACCESS_KEY_ID" {
  description = "AWS access key ID for Terraform to authenticate with AWS"
  type        = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS secret access key for Terraform to authenticate with AWS"
  type        = string
}

variable "ECR_REGISTRY" {
  description = "ECR registry URL"
  type        = string
}

variable "ECR_REPOSITORY" {
  description = "ECR repository name"
  type        = string
}