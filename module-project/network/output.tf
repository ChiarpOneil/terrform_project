output "tgt" {
    value = { for k, v in aws_ec2_transit_gateway.main : k => v.id }
}
output "natgt" {
    value = { for k, v in aws_nat_gateway.main : k => v.id }
}
output "igt" {
    value = { for k, v in aws_internet_gateway.main : k => v.id }
}
output "az" {
  value = { for k, v in aws_eip.main : k => v.id }
}