module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "vpc-${var.name}"
  cidr = "10.0.0.0/21"

  azs            = data.aws_availability_zones.available.names
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "secgroup-${var.name}"
  description = "Security group for ${var.name} server"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = var.port
      to_port     = var.port
      protocol    = "udp"
      description = "Wireguard service port"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp"]
  egress_rules        = ["all-all"]

}
