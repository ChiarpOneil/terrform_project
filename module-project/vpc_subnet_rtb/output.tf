output "vpc" {
    value = { for k, v in aws_vpc.main : k => v.id }
}
output "subnet"{
    value = { for k, v in aws_subnet.main : k => v.id }
}
output "routetable" {
    value = { for k, v in aws_route_table.main : k => v.id }
}
