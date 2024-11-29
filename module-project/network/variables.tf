variable "natgt" {
  description = "nat gateway variable"
  type = map(object({
    a_z = string
    subnet = string
  }))
  default = {
    "natgt" = {
      a_z = ""
      subnet = ""
    }
  }
}

variable "igt" {
    description = "internet gateway variable"
    type = map(string)
    default = {
        igt = ""
    }
}

variable "az" {
  description = "aviability zone vairable"
  type = map(string)
  default = {
    az = ""
  }
}

variable "tgt" {
  description = "transit gateway variable"
  type = map(number)
  default = {
    tgt = 0
  }
}

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