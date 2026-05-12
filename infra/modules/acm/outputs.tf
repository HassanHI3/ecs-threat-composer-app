output "certificate_arn" {
    value = aws_acm_certificate.threatmod_cert.arn
}

output "certificate_validation_arn" {
    value = aws_acm_certificate_validation.threatmod_cert_validation.certificate_arn
}

output "certificate_domain_name" {
    value = aws_acm_certificate.threatmod_cert.domain_name
}