output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.ecs_threat_composer_app.repository_url
}

output "ecr_repository_arn" {
  description = "ARN of the ECR repository"
  value       = aws_ecr_repository.ecs_threat_composer_app.arn
}

output "ecr_repository_name" {
  description = "Name of the ECR repository"
  value       = aws_ecr_repository.ecs_threat_composer_app.name
}