output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.ecs_threat_composer_vpc.id
}

output "alb_arn" {
  description = "ARN of the application load balancer"
  value       = aws_lb.threatmod_application_load_balancer.arn
}

output "alb_dns_name" {
  description = "DNS name of the application load balancer"
  value       = aws_lb.threatmod_application_load_balancer.dns_name
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.threatmod_cluster.name
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.threatmod_cluster_service.name
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.ecs_threat_composer_app.repository_url
}

output "cloudwatch_log_group_name" {
  description = "CloudWatch log group name"
  value       = aws_cloudwatch_log_group.threatmod_task_log_group.name
}