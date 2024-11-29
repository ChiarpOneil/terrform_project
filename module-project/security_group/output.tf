output "security_group" {
    value = { for k, v in aws_security_group.main : k => v.id }
}