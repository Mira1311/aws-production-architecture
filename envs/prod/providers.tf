terraform {
	required_version = ">= 1.0.0"
	
	backend "s3" {
		bucket		= "mira1311-core-ops-vault-2026"
		key		= "prod/sys-arch.tfstate"
		region		= "ap-southeast-1"
		dynamodb_table	= "mira1311-core-sync-registry"
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
				Environment	= "Production"
				Project		= "AWS-Production-Architecture"
				ManagedBy	= "Terraform"
				Owner		= "Mira1311"
			}
		}
	}
