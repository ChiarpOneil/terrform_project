variable "load_balancer" {
    description = "load balancer variable"
    type = map(object({
        security_groups = list(string)
        subnets = list(string)
        target_group = string
        ec2 = string
        protocol = string
        port = number}))
    default = {
        load_balancer = {
            security_groups = [""]
            subnets = [""]
            target_group = ""
            ec2 = ""
            protocol = ""
            port = 0
        }
    }
}

variable "subnet_ids" {
    description = "subnet_ids"
    type = map(string)
    default = {
      subnet_id = ""
    }
}

variable "security_group_ids" {
    description = "security_group_ids"
    type = map(string)
    default = {
      security_group = ""
    }
}

variable "vpc_ids" {
    description = "vpc_ids"
    type = map(string)
    default = {
      vpc_id = ""
    }
}

variable "ec2_ids" {
  description = "ec2_ids"
  type = map(string)
  default = {
    ec2_id = ""
  }
}