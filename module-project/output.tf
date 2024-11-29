output "tgt_id" {
    value = module.network.tgt
}
output "igt_id" {
    value = module.network.igt
}
output "natgt_id" {
    value = module.network.natgt
}
output "az_id" {
    value = module.network.az
}

output "vpc_ids" {
    value = module.vpc_subnet_rtb.vpc
}
output "subnet_id" {
    value = module.vpc_subnet_rtb.subnet
}
output "route_table_id" {
    value = module.vpc_subnet_rtb.routetable
}

output "security_group_id" {
  value = module.security_group.security_group
}