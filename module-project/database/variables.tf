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

variable "db" {
  description = "databse variables"
  type = list(object({
    db_name                 = string
    vpc_security_group_ids = list(string)
    db_subnet_group_name = string
    engine                  = string
    engine_version          = string
    instance_class          = string
    username                = string
    password                = string
    parameter_group_name    = string
  }))
  default = [{
    db_name = ""
    db_subnet_group_name = ""
    vpc_security_group_ids = [ "" ]
    engine                  = ""
    engine_version          = ""
    instance_class          = ""
    username                = ""
    password                = ""
    parameter_group_name    = ""
  }]
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

variable "snapshot" {
  description = "snapshot variables"
  type = list(object({
    id = string
    name = string
  }))
  default = [{
    id = ""
    name = ""
  }]
}

variable "security_group" {
  description = "subnet group variables"
  type = list(object({
    name = string
    subnet_ids = list(string)
  }))
  default = [ {
    name = ""
    subnet_ids = [ "" ]
  } ]
}
