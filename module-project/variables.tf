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
        }))
        attachments = map(object({
          gateway = string
          subnets = list(string)
          dns_support = string
        }))
    }))
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
    
}

variable "natgt" {
  description = "nat gateway variable"
  type = map(object({
    a_z = string
    subnet = string
  }))
}

variable "igt" {
    description = "internet gateway variable"
    type = map(string)
}

variable "az" {
  description = "aviability zone vairable"
  type = map(string)
}

variable "tgt" {
  description = "transit gateway variable"
  type = map(number)
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
}

variable "dhcp" {
  description = "dhcp variables"
  type = map(object({
    domain_name = string
    domain_name_servers = list(string)
    vpc = list(string)
  }))
}

variable "route_53" {
    description = "R53 variables"
    type = list(string)
}

variable "records"{
    description = "Record R53 variables"
    type = object({
        //name = string
        zone_id = list(string)
        type = list(string)
        ec2 = list(string)
    })
}

variable "endpoint" {
    description = "endpoint variables"
    type = map(object({
        vpc = string
        security_groups = list(string)
    }))
}

variable "load_balancer" {
    description = "load balancer variable"
    type = map(object({
        security_groups = list(string)
        subnets = list(string)
        target_group = string
        ec2 = string
        protocol = string
        port = number}))
}

variable "db" {
  description = "databse variables"
  type = list(object({
    db_name                 = string
    vpc_security_group_ids = list(string)
    db_subnet_group_name = string
    snapshot = optional(string)
    engine                  = optional(string)
    engine_version          = optional(string)
    instance_class          = string
    username                = optional(string)
    password                = optional(string)
    parameter_group_name    = optional(string)
  }))
}

variable "db_snap" {
  description = "databse variables"
  type = list(object({
    vpc_security_group_ids = list(string)
    db_subnet_group_name = string
    snapshot = string
    instance_class = string
  }))
  default = [{
    db_subnet_group_name = ""
    vpc_security_group_ids = [ "" ]
    snapshot = ""
    instance_class = ""
  }]
}


variable "security_group" {
    description = "subnet group variables"
    type = list(object({
        name = string
        subnet_ids = list(string)
    }))
}

variable "snapshot" {
  description = "snapshot variables"
  type = list(object({
    name = string
    id = string
  }))
}

#IDS
variable "vpc_ids" {
    description = "vpc_ids"
    type = map(string)
    default = {
        vpc_id = ""
    }
}

variable "subnet_ids" {
    description = "subnet_ids"
    type = map(string)
    default = {
      subnet_id = ""
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

variable "security_group_ids" {
    description = "security_group_ids"
    type = map(string)
    default = {
      security_group = ""
    }
}

variable "ec2_ids" {
  description = "ec2_ids"
  type = map(string)
  default = {
    ec2_id = ""
  }
}

variable "ec2_ips" {
  description = "ec2_ips"
  type = map(string)
  default = {
    ec2_id = ""
  }
}