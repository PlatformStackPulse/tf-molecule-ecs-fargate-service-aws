output "cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = module.cluster.arn
}

output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.cluster.name
}

output "task_definition_arn" {
  description = "ARN of the task definition"
  value       = module.task_definition.arn
}

output "service_name" {
  description = "Name of the ECS service"
  value       = module.service.name
}

output "service_id" {
  description = "ID of the ECS service"
  value       = module.service.id
}
