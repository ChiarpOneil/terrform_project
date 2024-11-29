#CREAZIONE TRASIT GATEWAY
resource "aws_ec2_transit_gateway" "main" {
    for_each = var.tgt 
    amazon_side_asn = each.value
    default_route_table_association = "disable"
    default_route_table_propagation = "disable"
    tags = {
      Name = "GIOVANNI-${each.key}"
    }
}
#CREAZIONE AVAILABILTY ZONE
resource "aws_eip" "main" {
    for_each = var.az
    domain = each.value
    tags = {
      Name = "GIOVANNI-${each.key}"
    }
}
#CREAZIONE INTERNET GATEWAY
resource "aws_internet_gateway" "main" {
    for_each = var.igt
    vpc_id = var.vpc_ids[each.value]
    tags = {
      Name = "GIOVANNI-${each.key}"
    }
}
#CREAZIONE NAT 
resource "aws_nat_gateway" "main" {
    for_each = var.natgt
    allocation_id = aws_eip.main[each.value.a_z].id
    subnet_id     = var.subnet_ids[each.value.subnet]
    depends_on = [ aws_internet_gateway.main ]
    tags = {
      Name = "GIOVANNI-${each.key}"
    }
}