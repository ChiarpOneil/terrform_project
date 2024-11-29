#CREAZIONE DHCP
resource "aws_vpc_dhcp_options" "main" {
  for_each = var.dhcp
  domain_name = each.value.domain_name
  domain_name_servers = each.value.domain_name_servers
  tags = {
    Name = "GIOVANNI-${each.key}"
  }
}

#CREAZIONE DHCP ASSOCIATIONS
resource "aws_vpc_dhcp_options_association" "main" {
  count = length(local.associations)
  dhcp_options_id = aws_vpc_dhcp_options.main[local.associations[count.index].dhcp].id
  vpc_id = var.vpc_ids[local.associations[count.index].vpc]
}

locals {
  associations = [ for association in flatten(
    [for dhcp_key, dhcp in var.dhcp:
      [ for association_key, association in dhcp.vpc: {
      dhcp = dhcp_key
      association_key = association_key
      vpc = association}]]): association]
}