terraform {
	required_providers {
		aws = {
			source = "hashicorp/aws"
			version = "5.37.0"
		}
	}
 
	backend "s3" {
		region = "eu-south-1"
		key = "giovanni-lab-n01/terraform.tfstate" 
		bucket = "terraform-state-ousidai6"
		dynamodb_table = "terraform-state-ousidai6"
		encrypt = true
	}
}
 
provider "aws" {
	region = local.config.region
 
	default_tags {
		tags = local.config.tags
	}
 
	ignore_tags {
		key_prefixes = ["kubernetes.io/", "Kyndryl_CTO_VPC_Flow_logs"]
	}
}
 
 
provider "aws" {
	region = "eu-central-1"
	alias = "milano"
 
	default_tags {
		tags = local.config.tags
	}

	ignore_tags {
		key_prefixes = ["kubernetes.io/", "Kyndryl_CTO_VPC_Flow_logs"]
	}
}

locals {
	config = yamldecode(file("data/config.yaml"))
}