################################################################################
# Service
################################################################################
data "aws_ssm_parameter" "fluentbit_backend" {
  name = "/aws/service/aws-for-fluent-bit/stable"
}
module "ecs_service_backend" {
  source = "./modules/service"

  name        = var.ecs_service_backend_name
  cluster_arn = module.ecs_cluster.arn

  cpu    = var.ecs_service_backend_cpu
  memory = var.ecs_service_backend_memory

  # Container definition(s)
  container_definitions = {

    #TODO : Kindly check for fluent_bit
     fluent-bit = {
      cpu       = 512
      memory    = 1024
      essential = true
      image     = nonsensitive(data.aws_ssm_parameter.fluentbit_backend.value)
      firelens_configuration = {
        type = "fluentbit"
      }
      memory_reservation = 50
      user               = "0"
    }

    (var.ecs_backend_container_name) = {
      cpu       = 1024
      memory    = 2048
      essential = true
      image     = "${var.image_uri}/${var.service_backend_repo_name}:${var.service_image_tag}"
      port_mappings = [
        {
          name          = var.ecs_backend_container_name
          containerPort = var.ecs_backend_container_port
          hostPort      = var.ecs_backedn_container_hostport
          protocol      = "tcp"
          appProtocol="http"
          
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
      target_group_arn = element(module.alb_backend.target_group_arns, 0)
      container_name   = var.ecs_backend_container_name
      container_port   = var.ecs_backend_container_port
    }
  }


  subnet_ids = module.vpc.private_subnets
  security_group_rules = {
    alb_ingress_3000 = {
      type                     = "ingress"
      from_port                = var.ecs_backend_container_port
      to_port                  = var.ecs_backend_container_port
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

module "alb_backend" {
  source  = "terraform-aws-modules/alb/aws"
  version = "8.6.0"

  name = var.ecs_backend_alb_name
  internal = true
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
      name             = var.ecs_backend_alb_tg_name
      backend_protocol = "HTTP"
      backend_port     = var.ecs_backend_container_port
      target_type      = "ip"
      health_check = {
        path                = "/api/v1"
        protocol            = "HTTP"
        port                = "traffic-port"
        interval            = 30
        timeout             = 10
        healthy_threshold   = 3
        unhealthy_threshold = 3
      }
    },
  ]

  tags = local.tags
}