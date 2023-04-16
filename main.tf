provider "aws" {
  region = "ap-northeast-1"

  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
}

module "ecs_fargate" {
  source = "./tf"

  security_groups = [module.sg.security_group_id]
  subnets         = module.vpc.public_subnets
  vpc_id          = module.vpc.vpc_id
  container_port  = "8080"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.1"

  name               = "dev"
  cidr               = "10.0.0.0/16"
  enable_nat_gateway = false

  azs            = ["ap-northeast-1"]
  public_subnets = ["10.0.101.0/24"]

  tags = {
    Environment = "dev"
  }
}

module "sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.1"

  name = "dev"
  vpc_id = module.vpc.vpc_id
}