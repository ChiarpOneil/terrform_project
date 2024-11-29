#CREAZIONE SECURITY GROUP
resource "aws_security_group" "main" {
  for_each = var.security_groups
  vpc_id = var.vpc_ids[each.value.vpc]
  dynamic "ingress" {
    for_each = each.value.ingress
    content {
        from_port   = ingress.value.from_port
        to_port     = ingress.value.to_port
        protocol    = ingress.value.protocol
        cidr_blocks = ingress.value.cidr_blocks
    }
  }
  dynamic "egress" {
    for_each = each.value.egress
    content {
        from_port   = egress.value.from_port
        to_port     = egress.value.to_port
        protocol    = egress.value.protocol
        cidr_blocks = egress.value.cidr_blocks
    }
  }
  tags = {
      Name = "GIOVANNI-${each.key}"
    }
}