output "ec2" {
  value = { for k, v in aws_instance.main : k => v.id }
}
output "ec2_ip" {
  value = { for k, v in aws_instance.main : k => v.private_ip }
}
