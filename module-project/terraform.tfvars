vpc_variables = {
    A = {
        cidr_block = "10.140.0.0/22"
        subnets = {
            public_1 = {
                cidr = "10.140.0.0/24"
                a_z = "eu-south-1a"
            }
            public_2 = {
                cidr = "10.140.1.0/24"
                a_z = "eu-south-1b"
            }
            transit_1 = {
                cidr = "10.140.2.0/28"
                a_z = "eu-south-1a"
            }
            transit_2 =  {
                cidr = "10.140.2.16/28"
                a_z = "eu-south-1b"
            }
        }
        route_tables = {
            route_public_a = {
                routes = {
                    route_ig_0 = {
                        cidr = "0.0.0.0/0"
                        gateway =  "igt"
                    }
                    route_tgw_A = {
                        cidr = "10.140.0.0/16"
                        gateway = "tgt"
                    }
                }
                subnets = ["public_1", "public_2"]
            }
            route_transit_a = {
                routes = {
                    route_nat_0 = {
                        cidr = "0.0.0.0/0"
                        gateway = "natgt"
                    }
                }
                subnets = ["transit_1", "transit_2"]
            }
        }
        attachments = {
            attachment = {
                gateway = "tgt"
                subnets = ["transit_1", "transit_2"]
                dns_support = "enable"
            }
        }
    }
    B = {
        cidr_block = "10.140.4.0/22"
        subnets = {
            private_1 = {
                cidr ="10.140.4.0/24"
                a_z = "eu-south-1a"
                }
            private_2 = {
                cidr = "10.140.5.0/24"
                a_z = "eu-south-1b"
                }
            transit_1 = {
                cidr = "10.140.6.0/28"
                a_z = "eu-south-1a"
                }
            transit_2 = {
                cidr = "10.140.6.16/28"
                a_z = "eu-south-1b"
                }
        }
        route_tables = {
            route_transit_b = {
                routes = {}
                subnets = ["transit_1", "transit_2"]
            }
            route_private_b =  {
                routes = {
                    route_tgw_0 = {
                        cidr = "0.0.0.0/0"
                        gateway = "tgt"
                    }
                }
                subnets = ["private_1", "private_2"]
            }
        }
        attachments = {
            attachment = {
                gateway = "tgt"
                subnets = ["transit_1", "transit_2"]
                dns_support = "enable"
            }
        }
    }
    C = {
        cidr_block = "10.140.8.0/22"
        subnets = {
            private_1 = {
                cidr = "10.140.8.0/24"
                a_z = "eu-south-1a"
                }
            private_2 = {
                cidr = "10.140.9.0/24"
                a_z = "eu-south-1b"
                }
            transit_1 = {
                cidr = "10.140.10.0/28"
                a_z = "eu-south-1a"
                }
            transit_2 = {
                cidr = "10.140.10.16/28"
                a_z = "eu-south-1b"
            }
        }
        route_tables = {
            route_transit_c = {
                routes = {
                    route_tgw_0 = {
                        cidr = "0.0.0.0/0"
                        gateway = "tgt"
                    }
                }
                subnets = ["transit_1", "transit_2"]
            }
            route_private_c = {
                routes = {
                    route_tgw_0 = {
                        cidr = "0.0.0.0/0"
                        gateway = "tgt"
                    }
                }
                subnets = ["private_1", "private_2"]
            }
        }
        attachments = {
            attachment = {
                gateway =  "tgt"
                subnets = ["transit_1", "transit_2"]
                dns_support = "enable"
            }
        }
    }
}

route_table = {
    route = {
      tgt = "tgt"
      attachment = ["A.attachment","C.attachment","B.attachment"]
      static = [{
        cidr = "0.0.0.0/0"
        attachment = "A.attachment"
      }]
      propagation = ["C.attachment", "B.attachment"]
    }
}

natgt = {
    natgt = {
      a_z = "az"
      subnet = "A.public_1"
    }
}

igt = {
    igt = "A"
}

az = {
     az = "vpc"
}

tgt = {
    tgt = 64512
}

security_groups = {
    security_group_a = {
        vpc = "A"
        ingress = {
            ingress = {
                from_port   = 80
                to_port     = 80
                protocol    = "tcp"
                cidr_blocks = ["10.140.0.0/16"]
            }
        }
        egress = {
            egress = {
                from_port   = 80
                to_port     = 80
                protocol    = "tcp"
                cidr_blocks = ["10.140.0.0/16"]
            }
        }
    }
    security_group_b = {
        vpc = "B"
        ingress = {
            ingress = {
                from_port   = -1
                to_port     = -1
                protocol    = "icmp"
                cidr_blocks = ["10.140.0.0/16"]
            }
        }
        egress = {
            egress = {
                from_port   = 0
                to_port     = 0
                protocol    = "-1"
                cidr_blocks = ["0.0.0.0/0"]
            }
        }
    }
    security_group_c = {
        vpc = "C"
        ingress = {
            ingress = {
                from_port   = -1
                to_port     = -1
                protocol    = "icmp"
                cidr_blocks = ["10.140.0.0/16"]
            }
        }
        egress = {
            egress = {
                from_port   = 0
                to_port     = 0
                protocol    = "-1"
                cidr_blocks = ["0.0.0.0/0"]
            }
        }
    }
}

ec2 = {
    ec2_a_1 = {
        subnet = "A.public_1"
        security_groups = "security_group_a"
        user_data = true
        ami                    = "ami-016bf72b6069c1527"
        instance_type          = "t3.nano"
    }
    ec2_a_2 = {
        subnet = "A.public_2"
        security_groups = "security_group_a"
        user_data = true
        ami                    = "ami-016bf72b6069c1527"
        instance_type          = "t3.nano"
    }
    ec2_b = {
        subnet = "B.private_1"
        security_groups = "security_group_b"
        user_data = false
        ami                    = "ami-016bf72b6069c1527"
        instance_type          = "t3.nano"
    }
    ec2_c = {
        subnet = "C.private_1"
        security_groups = "security_group_c"
        user_data = false
        ami                    = "ami-016bf72b6069c1527"
        instance_type          = "t3.nano"
    }
}

dhcp = {
    dhcp = {
        domain_name = "giovanni.local"
        domain_name_servers = ["AmazonProvidedDNS"]
        vpc =  ["A","B","C"]
    }
}

route_53 = ["giovanni.local","140.10.in-addr.arpa"]

records = {
    zone_id = ["giovanni.local","140.10.in-addr.arpa"]
    type = ["A","PTR"]
    ec2 = ["ec2_a_1","ec2_a_2","ec2_b","ec2_c"]
}

endpoint = {
    endpoint_b = {
            vpc = "B"
            security_groups = ["security_group_b"]
        }
    endpoint_c = {
        vpc = "C"
        security_groups = ["security_group_c"]
    }
}

load_balancer = {
    load_balancer = {
        security_groups = ["security_group_a"]
        subnets = ["A.transit_1","A.transit_2"]
        target_group = "A"
        ec2 = "ec2_a_1"
        protocol = "HTTP"
        port = 80
    }
}

db = [{
    db_name = "mydb"
    db_subnet_group_name = "subnet_group_name_1"
    vpc_security_group_ids = [ "security_group_b" ]
    engine                  = "mysql"
    engine_version          = "8.0"
    instance_class          = "db.t3.micro"
    username                = "owner"
    password                = "H4ard2find"
    parameter_group_name    = "default.mysql8.0"
  }
]

db_snap = [
    {
        db_subnet_group_name = "subnet_group_name_1"
        vpc_security_group_ids = [ "security_group_b" ]
        snapshot = "mydbsnapshot"
        instance_class          = "db.t3.micro"
  }
]

security_group = [ {
    name = "subnet_group_name_1"
    subnet_ids = ["B.private_1","B.private_2"]
} ]

snapshot = [{
    name = "mydbsnapshot"
    id = "mydb"
}]
