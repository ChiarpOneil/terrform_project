#MODULO VPC SUBNET ROUTE TABLE
module "vpc_subnet_rtb" {
    source = "./vpc_subnet_rtb/"
    vpc_variables = var.vpc_variables
    route_table = var.route_table
    natgt_ids = module.network.natgt
    igt_ids = module.network.igt
    tgt_ids = module.network.tgt
}
#MODULO NET GATEWAY INTERNET GATEWAY AVAILABILITY ZONE TRANSIT GATEWAY
module "network" {
  source = "./network/"
  igt = var.igt
  natgt = var.natgt
  tgt = var.tgt
  az = var.az
  vpc_ids = module.vpc_subnet_rtb.vpc
  subnet_ids = module.vpc_subnet_rtb.subnet
}
#MODULO SECURITY GROUP
module "security_group" {
  source = "./security_group/"
  security_groups = var.security_groups
  vpc_ids = module.vpc_subnet_rtb.vpc
}
#MODULO INSTANCE EC2
module "ec2" {
  source = "./ec2/"
  ec2 = var.ec2
  security_group_ids = module.security_group.security_group
  subnet_ids =  module.vpc_subnet_rtb.subnet
}
#MODULO DHCP OPTIONS
module "dhcp" {
  source = "./dhcp/"
  dhcp = var.dhcp
  vpc_ids = module.vpc_subnet_rtb.vpc
}
#MODULO ROUTE53
module "r53" {
  source = "./r53/"
  route_53 = var.route_53
  records = var.records
  ec2_ips = module.ec2.ec2_ip
  vpc_ids = module.vpc_subnet_rtb.vpc
}
#MODULO ENDPOINT
module "endpoint" {
  source = "./endpoint/"
  endpoint = var.endpoint
  security_group_ids = module.security_group.security_group
  vpc_ids = module.vpc_subnet_rtb.vpc
}
#MODULO LOAD BALANCER
module "load_balancer" {
  source = "./load_balancer/"
  load_balancer = var.load_balancer
  security_group_ids = module.security_group.security_group
  subnet_ids = module.vpc_subnet_rtb.subnet
  vpc_ids = module.vpc_subnet_rtb.vpc
  ec2_ids = module.ec2.ec2

}

#MODULO DB
module "database" {
  source = "./database/"
  db = var.db
  db_snap = var.db_snap
  security_group = var.subnet_group
  snapshot = var.snapshot
  subnet_ids = module.vpc_subnet_rtb.subnet
  security_group_ids = module.security_group.security_group
}

#MODULO AUTO SCALING GROUP
module "auto_scaling_group" {
  source = "./auto_balance"
  for_each = var.auto_scaler
  auto_scaler = each.value
  subnet_ids = module.vpc_subnet_rtb.subnet
  target_group_arns = module.load_balancer.target_group
  security_group_ids = module.security_group.security_group
}