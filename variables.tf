
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
variable "ecs_service_backend_name" {
  description = "ECS Backedn Service Name"
  type        = string
  default     = "urbanpillar-backend-service"
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
variable "ecs_service_backend_cpu" {
  description = "ECS Backend Service CPU"
  type        = number
  default     = 2048
}

variable "ecs_service_backend_memory" {
  description = "ECS Backend Service Memory"
  type        = number
  default     = 8192
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
variable "ecs_backend_container_name" {
  description = "ECS Backend Container Name"
  type        = string
  default     = "urbanp-bck-container"
}
variable "ecs_backend_container_port" {
  description = "ECS backend Container Port"
  type        = number
  default     = 4000
}
variable "ecs_backedn_container_hostport" {
  description = "ECS Backend Container Hostport"
  type        = number
  default     = 4000
}

variable "ecs_alb_name" {
  description = "ECS Loadbalancer Name"
  type        = string
  default     = "urbanpillar-alb"
}
variable "ecs_backend_alb_name" {
  description = "ECS Backed Loadbalancer Name"
  type        = string
  default     = "urbanpillar-backend-alb"
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
variable "ecs_backend_alb_tg_name" {
  description = "ECS Backend Loadbalancer Target Group Name"
  type        = string
  default     = "urb-bck-tg"
}
variable "terraform_s3_bucket_name" {
  description = "Terraform S3 Bucket Name where terraform state will be stored"
  type        = string
  default     = "urbanpillar-bucket-cf"
}
variable "terraform_s3_bucket_key" {
  description = "Terraform S3 Bucket path under which state file will be stored"
  type        = string
  default     = "terraform/state"
}
variable "terraform_dynomodb_table_name" {
  description = "Terraform state locking table"
  type        = string
  default     = "terraform_state_lock"
}
variable "image_uri" {
  description = "image uri"
  type        = string
  default     = "317910450301.dkr.ecr.ap-south-1.amazonaws.com"
}
variable "service_repo_name" {
  description = "Frontend service repository name"
  type        = string
  default     = "urbanpillar"
}
variable "service_backend_repo_name" {
  description = "Backend service repository name"
  type        = string
  default     = "urbanpillar-backend"
}
variable "service_image_tag" {
  description = "service image tag"
  type        = string
  default     = "latest"
}
variable "lambda_function_backend_name" {
  description = "Lambda function for backend service"
  type        = string
  default     = "lambda_register_backend_ecstaskdefinition"
}
variable "lambda_function_service_name" {
  description = "Lambda function for frontend service"
  type        = string
  default     = "lambda_register_service_ecstaskdefinition"
}