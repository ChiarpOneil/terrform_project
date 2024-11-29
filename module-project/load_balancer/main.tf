#CREAZIONE LOAD BALANCER
resource "aws_lb" "main"{
  for_each = var.load_balancer
  load_balancer_type = "application"
  internal = "false" 
  security_groups = [for security_group in each.value.security_groups:
    var.security_group_ids[security_group]]
  subnets = [for subnet in each.value.subnets:
    var.subnet_ids[subnet]]
}

#CREAZIONE TARGET GROUP
resource "aws_lb_target_group" "main" {
  for_each = var.load_balancer
  port     = each.value.port
  protocol = each.value.protocol
  vpc_id   = var.vpc_ids[each.value.target_group]
  health_check {
    port = each.value.port
    protocol = each.value.protocol
  }
}

#CREAZIONE TARGET GROUP ATTACHMENT
resource "aws_lb_target_group_attachment" "lb_tg_attachments" {
  for_each         = var.load_balancer
  target_group_arn = aws_lb_target_group.main[each.key].arn
  target_id        = var.ec2_ids[each.value.ec2]
  port             = each.value.port
}

#CREAZIONE LISTENER
resource "aws_lb_listener" "main" {
  for_each = var.load_balancer
  load_balancer_arn = aws_lb.main[each.key].arn
  port = each.value.port
  protocol = each.value.protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main[each.key].arn
  }
}