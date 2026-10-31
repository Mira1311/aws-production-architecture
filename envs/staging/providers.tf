terraform {
	required_version = ">= 1.0.0"

	backend "s3" {
		bucket		= "mira1311-core-ops-vault-2026"
		key		= "staging/sys-arch.tfstate"
		region		= "ap-southeast-1"
		use_lockfile	= true
		encrypt		= true
	}

	required_providers {
		aws = {
			source	= "hashicorp/aws"
			version	= "~> 5.0"
	              }
		}
	}

provider "aws" {
	region = "ap-southeast-1"
	
	default_tags {
		tags = {
			Environment	= "Staging"
			Project		= "AWS-Production-Architecture"
			ManagedBy	= "Terraform"
			Owner		= "Mira1311"
		}
	}
}



