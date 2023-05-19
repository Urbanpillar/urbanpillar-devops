locals {
  vpc_name = "urbanpillar-vpc-${random_string.suffix.result}"

  ingress_rules = [80,22]
}