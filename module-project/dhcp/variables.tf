variable "dhcp" {
  description = "dhcp variables"
  type = map(object({
    domain_name = string
    domain_name_servers = list(string)
    vpc = list(string)
  }))
  default = {
    dhcp = {
        domain_name = ""
        domain_name_servers = [""]
        vpc =  [""]
    }
  }
}

variable "vpc_ids" {
    type = map(string)
    default = {
        vpc_id = ""
    }
}