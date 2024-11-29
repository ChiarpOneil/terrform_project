variable "vpc_ids" {
    type = map(string)
    default = {
        vpc_id = ""
    }
}

variable "subnet_ids" {
    type = map(string)
    default = {
      subnet_id = ""
    }
}

variable "security_groups" {
    description = "security group variable"
    type = map(object({
        vpc = string
        ingress = map(object({
            from_port   = number
            to_port     = number
            protocol    = string
            cidr_blocks = list(string)
        }))
        egress = map(object({
            from_port   = number
            to_port     = number
            protocol    = string
            cidr_blocks = list(string)
        }))
    }))
    default = {
      security_group = {
        vpc = ""
        ingress = {
            ingress = {
                from_port   = -1
                to_port     = -1
                protocol    = ""
                cidr_blocks = [""]
            }
        }
        egress = {
            egress = {
                from_port   = -1
                to_port     = -1
                protocol    = ""
                cidr_blocks = [""]
            }
        }
      }
    }
}