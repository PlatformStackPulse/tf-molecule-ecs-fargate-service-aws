variable "cpu" {
  description = "CPU units for the task (256, 512, 1024, 2048, 4096)"
  type        = string
  default     = "256"
}

variable "memory" {
  description = "Memory in MiB for the task"
  type        = string
  default     = "512"
}

variable "execution_role_arn" {
  description = "ARN of the ECS task execution role"
  type        = string
  default     = null
}

variable "task_role_arn" {
  description = "ARN of the task role for container permissions"
  type        = string
  default     = null
}

variable "container_definitions" {
  description = "JSON-encoded container definitions"
  type        = string
  validation {
    condition     = can(jsondecode(var.container_definitions))
    error_message = "container_definitions must be valid JSON."
  }
}

variable "runtime_platform" {
  description = "Runtime platform (OS family and CPU architecture)"
  type = object({
    operating_system_family = string
    cpu_architecture        = string
  })
  default = null
}

variable "desired_count" {
  description = "Desired number of running tasks"
  type        = number
  default     = 1
}

variable "subnet_ids" {
  description = "Subnet IDs for the Fargate tasks"
  type        = list(string)
  validation {
    condition     = length(var.subnet_ids) > 0
    error_message = "At least one subnet ID is required."
  }
}

variable "security_group_ids" {
  description = "Security group IDs for the tasks"
  type        = list(string)
  default     = []
}

variable "assign_public_ip" {
  description = "Assign public IP to tasks"
  type        = bool
  default     = false
}

variable "load_balancer_config" {
  description = "Load balancer configuration for the service"
  type = object({
    target_group_arn = string
    container_name   = string
    container_port   = number
  })
  default = null
}

variable "container_insights_enabled" {
  description = "Enable CloudWatch Container Insights on the cluster"
  type        = bool
  default     = true
}

variable "deployment_minimum_healthy_percent" {
  description = "Minimum healthy percent during deployment"
  type        = number
  default     = 100
}

variable "deployment_maximum_percent" {
  description = "Maximum percent during deployment"
  type        = number
  default     = 200
}

variable "health_check_grace_period_seconds" {
  description = "Health check grace period (when using LB)"
  type        = number
  default     = null
}

variable "enable_execute_command" {
  description = "Enable ECS Exec for debugging"
  type        = bool
  default     = false
}
