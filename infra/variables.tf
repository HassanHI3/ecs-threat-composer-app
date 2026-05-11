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

# variable "certificate_arn" {
#   description = "ACM certificate ARN for the HTTPS listener"
#   type        = string
#   sensitive =  true
# }

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
  sensitive   = true
}

variable "execution_role_arn" {
  description = "IAM execution role ARN used by ECS to pull images and send logs"
  type        = string
  sensitive   = true
}
variable "ECR_REGISTRY" {
  description = "ECR registry URL"
  type        = string
}

variable "ECR_REPOSITORY" {
  description = "ECR repository name"
  type        = string
}

variable "cloudflare_api_token" {
  description = "value of the Cloudflare API token with permissions to manage DNS records"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "value of the Cloudflare zone ID for the domain where DNS records will be managed"
  type        = string
  sensitive   = true
}