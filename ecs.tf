################################################################################
# Cluster
################################################################################

module "ecs_cluster" {
  source = "./modules/cluster"

  cluster_name = var.ecs_cluster_name

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

  tags = local.tags
}

data "aws_ssm_parameter" "fluentbit" {
  name = "/aws/service/aws-for-fluent-bit/stable"
}

################################################################################
# Service
################################################################################

module "ecs_service" {
  source = "./modules/service"

  name        = var.ecs_service_name
  cluster_arn = module.ecs_cluster.arn

  cpu    = var.ecs_service_cpu
  memory = var.ecs_service_memory

  # Container definition(s)
  container_definitions = {

    #TODO : Kindly check for fluent_bit
     fluent-bit = {
      cpu       = 512
      memory    = 1024
      essential = true
      image     = nonsensitive(data.aws_ssm_parameter.fluentbit.value)
      firelens_configuration = {
        type = "fluentbit"
      }
      memory_reservation = 50
      user               = "0"
    }

    (var.ecs_container_name) = {
      cpu       = 1536
      memory    = 2048
      essential = true
      image     = "317910450301.dkr.ecr.ap-south-1.amazonaws.com/urbanpillar:latest"
      port_mappings = [
        {
          name          = var.ecs_container_name
          containerPort = var.ecs_container_port
          hostPort      = var.ecs_container_hostport
          protocol      = "tcp"
        }
      ]

      # Example image used requires access to write to root filesystem
      readonly_root_filesystem = false
      enable_cloudwatch_logging = false

    log_configuration = {
        logDriver = "awsfirelens"
        options = {
          Name                    = "firehose"
          region                  = var.region
          delivery_stream         = "my-stream"
          log-driver-buffer-limit = "2097152"
        }
      }

      memory_reservation = 100
    }
  }


  load_balancer = {
    service = {
      target_group_arn = element(module.alb.target_group_arns, 0)
      container_name   = var.ecs_container_name
      container_port   = var.ecs_container_port
    }
  }

  subnet_ids = module.vpc.private_subnets
  security_group_rules = {
    alb_ingress_3000 = {
      type                     = "ingress"
      from_port                = var.ecs_container_port
      to_port                  = var.ecs_container_port
      protocol                 = "tcp"
      description              = "Service port"
      source_security_group_id = module.alb_sg.security_group_id
    }
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = local.tags
}

module "alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "${var.ecs_alb_sg_name}-service"
  description = "Service security group"
  vpc_id      = module.vpc.vpc_id

  ingress_rules       = ["http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = module.vpc.private_subnets_cidr_blocks

  tags = local.tags
}


module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "8.6.0"

  name = var.ecs_alb_name
  load_balancer_type = "application"

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [module.alb_sg.security_group_id]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    },
  ]

  target_groups = [
    {
      name             = "${var.ecs_alb_tg_name}-${var.ecs_container_name}"
      backend_protocol = "HTTP"
      backend_port     = var.ecs_container_port
      target_type      = "ip"
    },
  ]

  tags = local.tags
}