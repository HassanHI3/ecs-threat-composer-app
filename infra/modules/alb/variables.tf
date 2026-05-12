variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnets for ALB"
  type        = list(string)
}

variable "certificate_arn" {
  description = "ACM cert ARN for HTTPS listener"
  type        = string
}

variable "container_port" {
  description = "Container port for target group"
  type        = number
  default     = 3003
}

variable "environment" {
  description = "Environment name"
  type        = string
}