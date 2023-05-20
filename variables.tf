
variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "ecs_cluster_name" {
  description = "ECS Cluster Name"
  type        = string
  default     = "urbanpillar-cluster"
}

variable "ecs_service_name" {
  description = "ECS Service Name"
  type        = string
  default     = "urbanpillar-service"
}

variable "ecs_service_cpu" {
  description = "ECS Service CPU"
  type        = number
  default     = 1024
}

variable "ecs_service_memory" {
  description = "ECS Service Memory"
  type        = number
  default     = 4096
}

variable "ecs_container_name" {
  description = "ECS Container Name"
  type        = string
  default     = "urbanpillar-container"
}
variable "ecs_container_port" {
  description = "ECS Container Port"
  type        = number
  default     = 80
}
variable "ecs_container_hostport" {
  description = "ECS Container Hostport"
  type        = number
  default     = 80
}

variable "ecs_alb_name" {
  description = "ECS Loadbalancer Name"
  type        = string
  default     = "urbanpillar-alb"
}

variable "ecs_alb_sg_name" {
  description = "ECS Loadbalancer Security Group Name"
  type        = string
  default     = "urbanpillar-alb-sg"
}

variable "ecs_alb_tg_name" {
  description = "ECS Loadbalancer Target Group Name"
  type        = string
  default     = "urbanp-tg"
}