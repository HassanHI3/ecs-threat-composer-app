variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "az_a" {
  description = "Primary AZ"
  type        = string
}

variable "az_b" {
  description = "Secondary AZ"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}
