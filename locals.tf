locals {
  vpc_name = "urbanpillar-vpc-${random_string.suffix.result}"
  ecs_cluster_name ="urbanpillar-cluster"
  tags = {
    name="urbanpillar"
    org = "kaycomm"
    author = "rakesh/ashutosh"
  }
  ecs_cluster_tags = local.tags
  ingress_rules = [80,22]
}