output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.threatmod_cluster.name
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.threatmod_cluster_service.name
}

output "ecs_service_id" {
  description = "ID of the ECS service"
  value       = aws_ecs_service.threatmod_cluster_service.id
}

output "ecs_task_security_group_id" {
  description = "Security group ID for ECS tasks"
  value       = aws_security_group.ecs_tasks_sg.id
}