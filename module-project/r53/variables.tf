variable "vpc_ids" {
    type = map(string)
    default = {
        vpc_id = ""
    }
}

variable "ec2_ips" {
  type = map(string)
  default = {
    ec2_id = ""
  }
}

variable "route_53" {
    description = "R53 variables"
    type = list(string)
    default = ["local","reverse"]
}

variable "records"{
    description = "Record R53 variables"
    type = object({
        //name = string
        zone_id = list(string)
        type = list(string)
        ec2 = list(string)
    })
    default = {
            //name = "name"
            zone_id = ["local","reverse"]
            type = ["A","PTR"]
            ec2 = ["e2"]
        }
}
