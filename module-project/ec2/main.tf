#CEAZIONE EC2 INSTANCE
resource "aws_instance" "main"{
  for_each = var.ec2
  ami                    = each.value.ami
  instance_type          = each.value.instance_type
  subnet_id              = var.subnet_ids[each.value.subnet]
  vpc_security_group_ids = [var.security_group_ids[each.value.security_groups]]
  user_data = each.value.user_data ? templatefile("./data/amazon2.sh.tftpl", {
    hostname = "${each.key}"
    vpc      = "A"
  }) : null
  tags = {
    Name = "GIOVANNI-${each.key}"
  }
}
