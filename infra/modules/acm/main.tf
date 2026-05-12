resource "aws_acm_certificate" "threatmod_cert" {
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "threatmod-cert"
    Environment = var.environment
  }
}

resource "cloudflare_dns_record" "tm_threatmodapp" {
  zone_id = var.cloudflare_zone_id
  name    = var.app_subdomain
  type    = "CNAME"
  content = var.alb_dns_name
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.threatmod_cert.domain_validation_options : dvo.domain_name => {
      name    = trimsuffix(dvo.resource_record_name, ".")
      content = trimsuffix(dvo.resource_record_value, ".")
      type    = dvo.resource_record_type
    }
  }

  zone_id = var.cloudflare_zone_id
  name    = each.value.name
  type    = each.value.type
  content = each.value.content
  ttl     = 1
  proxied = false
}

resource "aws_acm_certificate_validation" "threatmod_cert_validation" {
  certificate_arn = aws_acm_certificate.threatmod_cert.arn
  validation_record_fqdns = [
    for record in cloudflare_dns_record.acm_validation : record.name
  ]
}