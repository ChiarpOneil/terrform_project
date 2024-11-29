#CREAZIONE ENDPOINT
resource "aws_vpc_endpoint" "main_endpoints"{
  for_each = var.endpoint
  vpc_id            = var.vpc_ids[each.value.vpc]
  vpc_endpoint_type = "Interface"
  service_name      = "com.amazonaws.eu-south-1.ssm"
  security_group_ids = [for sec in each.value.security_groups: var.security_group_ids[sec]]
  tags = {
    Name = "Giovanni-${each.key}"
  }
}