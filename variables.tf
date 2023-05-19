
variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "default_security_group_ingress_rules" {
  description = "List of ingress rules for the default security group"
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
    cidr_blocks = list(string)
  }))
  default     = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = ["0.0.0.0/0"]
    },
    # Add more ingress rules if needed
    {
      from_port   = 80
      to_port     = 80
      protocol    = "http"
      description = "http"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "default_security_group_egress_rules" {
  description = "List of egress rules for the default security group"
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
    cidr_blocks = list(string)
  }))
  default     = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all outbound traffic"
      cidr_blocks = ["0.0.0.0/0"]
    }
    # Add more egress rules if needed
  ]
}
