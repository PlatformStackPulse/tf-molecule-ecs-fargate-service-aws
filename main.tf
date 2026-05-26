module "cluster" {
  source = "git::https://github.com/PlatformStackPulse/tf-atom-ecs-cluster-aws.git?ref=v1.1.0"

  enabled   = module.this.enabled
  namespace = var.namespace
  name      = var.name
  stage     = var.stage
  tags      = var.tags

  container_insights_enabled = var.container_insights_enabled
}

module "task_definition" {
  source = "git::https://github.com/PlatformStackPulse/tf-atom-ecs-task-definition-aws.git?ref=v1.1.0"

  enabled   = module.this.enabled
  namespace = var.namespace
  name      = var.name
  stage     = var.stage
  tags      = var.tags

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn
  container_definitions    = var.container_definitions
  runtime_platform         = var.runtime_platform
}

module "service" {
  source = "git::https://github.com/PlatformStackPulse/tf-atom-ecs-service-aws.git?ref=v1.1.0"

  enabled   = module.this.enabled
  namespace = var.namespace
  name      = var.name
  stage     = var.stage
  tags      = var.tags

  cluster_arn          = module.cluster.arn
  task_definition_arn  = module.task_definition.arn
  desired_count        = var.desired_count
  launch_type          = "FARGATE"
  network_mode         = "awsvpc"
  subnet_ids           = var.subnet_ids
  security_group_ids   = var.security_group_ids
  assign_public_ip     = var.assign_public_ip
  load_balancer_config = var.load_balancer_config

  deployment_minimum_healthy_percent  = var.deployment_minimum_healthy_percent
  deployment_maximum_percent          = var.deployment_maximum_percent
  health_check_grace_period_seconds   = var.health_check_grace_period_seconds
  enable_execute_command              = var.enable_execute_command
  deployment_circuit_breaker_enabled  = true
  deployment_circuit_breaker_rollback = true
}
