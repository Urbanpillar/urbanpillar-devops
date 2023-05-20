################################################################################
# Cluster
################################################################################

module "ecs_cluster" {
  source = "./modules/cluster"

  cluster_name = local.ecs_cluster_name

  # Capacity provider
  fargate_capacity_providers = {

    FARGATE = {
      default_capacity_provider_strategy = {
        base   = 2
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
  }

  tags = local.ecs_cluster_tags
}