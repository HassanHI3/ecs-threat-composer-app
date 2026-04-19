variable "vpc_id" {
  description = "VPC ID for the ECS task security group"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for ECS tasks"
  type        = list(string)
}

variable "target_group_arn" {
  description = "Target group ARN for the ECS service"
  type        = string
}

variable "alb_security_group_id" {
  description = "ALB security group ID allowed to reach ECS tasks"
  type        = string
}

variable "task_role_arn" {
  description = "IAM task role ARN"
  type        = string
}

variable "execution_role_arn" {
  description = "IAM execution role ARN"
  type        = string
}

variable "container_image" {
  description = "Container image URI"
  type        = string
}

variable "aws_region" {
  description = "AWS region for CloudWatch logs"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "listener_dependency" {
  description = "Listener resource dependency from load balancer module"
  type        = any
}