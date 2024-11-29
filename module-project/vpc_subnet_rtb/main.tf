#CREAZIONE VPC
resource "aws_vpc" "main" {
    for_each = var.vpc_variables
    cidr_block = each.value.cidr_block
    enable_dns_hostnames = true
    enable_dns_support   = true
    tags = {
      Name = "GIOVANNI-${each.key}"
    }
}
#CREAZIONE SUBNET
resource "aws_subnet" "main" {
    for_each = {for subnet in flatten([
        for vpc_key, vpc in var.vpc_variables : [
            for subnet_key, subnet in vpc.subnets : {
                vpc_key = vpc_key
                subnet_key  = subnet_key
                cidr  = subnet.cidr
                a_z = subnet.a_z}]]): "${subnet.vpc_key}.${subnet.subnet_key}" => subnet}
    vpc_id = aws_vpc.main[each.value.vpc_key].id
    cidr_block = each.value.cidr
    availability_zone = each.value.a_z
    tags = {
      Name = "GIOVANNI-${each.key}"
    }
}
#CREAZIONE TRANSITGATEWAY ATTACHMENT
resource "aws_ec2_transit_gateway_vpc_attachment" "main"{
  for_each = {for attachment in flatten([
    for vpc_key, vpc in var.vpc_variables: [
        for attachment_key, attachment in vpc.attachments: {
            vpc_key = vpc_key
            attachment_key = attachment_key
            gateway = attachment.gateway
            subnets = [for subnet_ind, subnet in attachment.subnets: "${vpc_key}.${subnet}"]
            dns_support = attachment.dns_support
        }
    ]
  ]):"${attachment.vpc_key}.${attachment.attachment_key}" => attachment} 
  transit_gateway_id = var.tgt_ids[each.value.gateway]
  vpc_id             = aws_vpc.main[each.value.vpc_key].id
  subnet_ids         = [for subnet_ind, subnet in each.value.subnets: aws_subnet.main[subnet].id]
  dns_support = each.value.dns_support
  tags = {
      Name = "GIOVANNI-${each.key}"
  }
}
#CREAZIONE ROUTE TABLE
resource "aws_route_table" "main"{
  for_each = {for route_table in flatten([
    for vpc_key, vpc in var.vpc_variables: [
      for route_table_key, route_table in vpc.route_tables: {
        vpc_key = vpc_key
        route_table_key = route_table_key
        routes = route_table.routes
      }
    ]
  ]):"${route_table.vpc_key}.${route_table.route_table_key}"=>route_table}
  vpc_id = aws_vpc.main[each.value.vpc_key].id
  dynamic "route" {
    for_each = each.value.routes
    content {
      cidr_block = route.value.cidr
      gateway_id = route.value.gateway == "local"? "local" : route.value.gateway == "igt"?  var.igt_ids[route.value.gateway] : null
      nat_gateway_id = route.value.gateway == "natgt"?  var.natgt_ids[route.value.gateway] :  null
      transit_gateway_id = route.value.gateway == "tgt"?  var.tgt_ids[route.value.gateway] :  null
    }
  }
  tags = {
      Name = "GIOVANNI-${each.key}"
  }
}
#CREAZIONE ASSOCIATION TABLE
resource "aws_route_table_association" "main"{
  for_each = {for association in flatten([
    for vpc_key, vpc in var.vpc_variables: [
      for route_table_key, route_table in vpc.route_tables: [
        for association in route_table.subnets: {
          vpc_key = vpc_key
          route_table_key = "${vpc_key}.${route_table_key}"
          subnet = "${vpc_key}.${association}"
        }  
      ] 
    ]
  ]): "${association.subnet}.${association.route_table_key}"=>association}
  subnet_id      = aws_subnet.main[each.value.subnet].id
  route_table_id = aws_route_table.main[each.value.route_table_key].id
}

#CREAZIONE ROUTE TABLE TO TRANSIT GATEWAY
resource "aws_ec2_transit_gateway_route_table" "main" {
  for_each = var.route_table
  transit_gateway_id = var.tgt_ids[each.value.tgt]
  tags = {
    Name = "GIOVANNI-${each.key}"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "main" {
  for_each = {for association in flatten([for route_table_key, route_table in var.route_table: [
    for attachment in route_table.attachment:{
      attachment = attachment
      route_table_key = route_table_key
    }
  ]]): "${association.route_table_key}.${association.attachment}"=>association}
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.main[each.value.attachment].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main[each.value.route_table_key].id
}

#CREAZIONE ROUTE TABLE TO TRANSIT GATEWAY
resource "aws_ec2_transit_gateway_route" "tgwrtb_VPC_A_static" {
    for_each = {for static in flatten([for route_table_key, route_table in var.route_table: [
    for static in route_table.static:{
      attachment = static.attachment
      route_table_key = route_table_key
      cidr = static.cidr
    }
  ]]): "${static.route_table_key}.${static.attachment}"=>static}
    destination_cidr_block         = each.value.cidr
    transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.main[each.value.attachment].id
    transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main[each.value.route_table_key].id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgwrtb_VPC_B" {
  for_each = {for propagation in flatten([for route_table_key, route_table in var.route_table: [
    for propagation in route_table.propagation:{
      attachment = propagation
      route_table_key = route_table_key
    }
  ]]): "${propagation.route_table_key}.${propagation.attachment}"=>propagation}
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.main[each.value.attachment].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main[each.value.route_table_key].id
}