variable "vpc_ids" {
    description = "vpc_ids"
    type = map(string)
    default = {
      vpc_id = ""
    }
}

variable "security_group_ids" {
    description = "security_group_ids"
    type = map(string)
    default = {
      security_group = ""
    }
}

variable "endpoint" {
    description = "endpoint variables"
    type = map(object({
        vpc = string
        security_groups = list(string)
    }))
    default = {
    endpoint = {
        vpc = ""
        security_groups = [""]
      }
    }
}