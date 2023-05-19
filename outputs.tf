output "region" {
  description = "AWS region"
  value       = var.region
}

output "vpc" {
  description = "VPC"
  value       = module.vpc.name
}

output "public_subnets" {
  description = "Public Subnets"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "Private Subnets"
  value       = module.vpc.private_subnets
}