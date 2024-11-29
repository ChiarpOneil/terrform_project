resource "aws_route53_zone" "main" {
  for_each = {for r53 in var.route_53: "${r53}" => {
    name = r53
    vpcs = var.vpc_ids
  }}
  name = each.value.name
  dynamic "vpc" {
    for_each = each.value.vpcs
    content {
        vpc_id = vpc.value
    } 
  }
  tags = {
      Name = "GIOVANNI-${each.key}"
  }
}

resource "aws_route53_record" "main" {
    for_each = { for record in flatten(
        [for ec2 in var.records.ec2:[
            {
                name = "${ec2}_record"
                type = var.records.type[0]
                zone_id = var.records.zone_id[0]
                ec2 = ec2
            },
            {
                name = ec2
                type = var.records.type[1]
                zone_id = var.records.zone_id[1]
                ec2 = "${ec2}_record"
            }]
        ]
    ): "${record.name}"=>record}
    zone_id = aws_route53_zone.main[each.value.zone_id].id
    name = each.value.type == "PTR"? "${element(split(".", var.ec2_ips[each.value.name]), 3)}.${element(split(".", var.ec2_ips[each.value.name]), 2)}.${element(split(".", var.ec2_ips[each.value.name]), 1)}.${element(split(".", var.ec2_ips[each.value.name]), 0)}.in-addr.arpa" : each.value.name
    records = [each.value.type == "PTR"? "${each.value.ec2}.giovanni.local" : var.ec2_ips[each.value.ec2]]
    type = each.value.type
    ttl = 300
}