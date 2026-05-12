output "ecs_cluster_id" {
  value = aws_ecs_cluster.threatmod_cluster.id
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.threatmod_cluster.name
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.threatmod_cluster.arn
}

output "ecs_service_name" {
  value = aws_ecs_service.threatmod_cluster_service.name
}

output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.threatmod_app_task.arn
}

output "ecs_task_family" {
  value = aws_ecs_task_definition.threatmod_app_task.family
}

output "ecs_tasks_security_group_id" {
  value = aws_security_group.ecs_threat_composer_tasks_sg.id
}

output "cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.threatmod_task_log_group.name
}