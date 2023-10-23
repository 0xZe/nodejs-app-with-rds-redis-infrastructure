#define aws
provider "aws" {
  region = "us-east-1"
}
module "vpc-network" {
  source               = "./vpc-network"
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  subnets_az           = var.subnets_az

}

module "rds-redis" {
  source             = "./rds-redis"
  appvpc_id          = module.vpc-network.appvpc_id
  private_subnets_id = [module.vpc-network.private_subnet_id, module.vpc-network.private_subnet2_id]

}

module "instances" {
  source             = "./instances"
  appvpc_id          = module.vpc-network.appvpc_id
  public_subnets_id  = [module.vpc-network.public_subnet_id, module.vpc-network.public_subnet2_id]
  private_subnets_id = [module.vpc-network.private_subnet_id, module.vpc-network.private_subnet2_id]
}

module "load-balancer" {
  source = "./load-balancer"

  appvpc_id          = module.vpc-network.appvpc_id
  private_subnets_id = [module.vpc-network.private_subnet_id, module.vpc-network.private_subnet2_id]
  public_subnets_id  = [module.vpc-network.public_subnet_id, module.vpc-network.public_subnet2_id]
  app-instance_id    = module.instances.app-instance_id
}
