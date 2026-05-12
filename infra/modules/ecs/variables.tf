variable "aws_region" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "alb_security_group_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "alb_listener_dependencies" {
  type    = any
  default = []
}

variable "container_image" {
  type = string
}

variable "container_name" {
  type = string
}

variable "container_port" {
  type    = number
  default = 3003
}

variable "task_cpu" {
  type    = string
  default = "1024"
}

variable "task_memory" {
  type    = string
  default = "2048"
}

variable "task_role_arn" {
  type      = string
  sensitive = true
}

variable "execution_role_arn" {
  type      = string
  sensitive = true
}

variable "desired_count" {
  type    = number
  default = 2
}

variable "autoscaling_min_capacity" {
  type    = number
  default = 2
}

variable "autoscaling_max_capacity" {
  type    = number
  default = 4
}