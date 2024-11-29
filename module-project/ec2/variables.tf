variable "security_group_ids" {
    description = "security_group_ids"
    type = map(string)
    default = {
      security_group = ""
    }
}

variable "subnet_ids" {
    description = "subnet_ids"
    type = map(string)
    default = {
      subnet_id = ""
    }
}

variable "ec2" {
    description = "ec2 variable"
    type = map(object({
        subnet = string
        security_groups = string
        user_data = bool
        ami = string
        instance_type = string
    }))
    default = {
      ec2 = {
        subnet = ""
        security_groups = ""
        user_data = false
        ami = ""
        instance_type = ""
      }
    }
}