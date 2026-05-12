# cSpell:disable
output "alb_arn" {
  value = aws_lb.threatmod_application_load_balancer.arn
}

output "alb_dns_name" {
  value = aws_lb.threatmod_application_load_balancer.dns_name
}

output "alb_zone_id" {
  value = aws_lb.threatmod_application_load_balancer.zone_id
}

output "alb_security_group_id" {
  value = aws_security_group.threatmod_application_load_balancer_sg.id
}

output "target_group_arn" {
  value = aws_lb_target_group.threatmod_target_group.arn
}

output "https_listener_arn" {
  value = aws_lb_listener.threatmod_alb_listener_https.arn
}

output "http_listener_arn" {
  value = aws_lb_listener.threatmod_alb_listener_for_redirect_http_to_https.arn
}