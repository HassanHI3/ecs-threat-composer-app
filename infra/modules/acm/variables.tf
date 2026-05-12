variable "environment" {
    type        = string
    description = "Environment name"
}

variable "domain_name" {
    type        = string
    description = "Primary domain name"
}

variable "subject_alternative_names" {
    type        = list(string)
    default     = []
    description = "Additional domain names for the certificate"
}

variable "app_subdomain" {
    type        = string
    description = "Application subdomain"
}

variable "alb_dns_name" {
    type        = string
    description = "ALB DNS name"
}

variable "cloudflare_zone_id" {
    type        = string
    sensitive   = true
    description = "Cloudflare zone ID"
}