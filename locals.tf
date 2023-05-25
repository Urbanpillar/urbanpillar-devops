locals {
  vpc_name = "urbanpillar-vpc-${random_string.suffix.result}"
  tags = {
    name="urbanpillar"
    org = "kaycomm"
    author = "rakesh/ashutosh"
  }
  ecs_cluster_tags = local.tags
  ingress_rules = [80,22]
  create_task_definition=true
}