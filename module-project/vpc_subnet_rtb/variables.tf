variable "vpc_variables" {
    description = "vpc struttura"
    type = map(object({
        cidr_block = string
        subnets = map(object({
            cidr = string
            a_z = string
        }))
        route_tables = map(object({
                routes = map(object({
                    cidr = string
                    gateway = string
                }))
                subnets = list(string)
            }
        ))
        attachments = map(object({
          gateway = string
          subnets = list(string)
          dns_support = string
        }))
    }))
    default = {
        A = {
            cidr_block = "0.0.0.0/22"
            subnets = {
                subnet = {
                    cidr ="0.0.0.0/24"
                    a_z = ""
                }
            }
            route_tables = {
                route_table = {
                    routes = {
                        route = {
                            cidr = "0.0.0.0"
                            gateway = ""
                        }
                    }
                    subnets = [""]
                }
            }
            attachments = {
                attachment = {
                    gateway = ""
                    subnets = [""]
                    dns_support = ""
                }
            }
        }
    }
}
variable "route_table" {
  description = "route_table variables"
  type = map(object({
    tgt = string
    attachment = list(string)
    static = list(object({
        cidr = string
        attachment = string
    }))
    propagation = list(string)
  }))
  default = {
    route = {
      tgt = ""
      attachment = [""]
      static = [{
        cidr = ""
        attachment = ""
      }]
      propagation = [""]
    }
  }
}

variable "tgt_ids" {
    description = "transit_gateway_ids"
    type = map(string)
    default = {
      tgt_id = ""
    }
}

variable "igt_ids" {
    description = "internet_gateway_ids"
    type = map(string)
    default = {
      igt_id = ""
    }
}

variable "natgt_ids" {
    description = "nat_gateway_ids"
    type = map(string)
    default = {
      natgt_id = ""
    }
}