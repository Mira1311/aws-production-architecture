variable "vpc_cidr_block" {
	description	= "IP range of the VPC ( CIDR BLOCK )"
	type		= string
}

variable "vpc_name" {
	description	= "VPC Name"
	type		= string
}

variable "environment" {
	description	= "Environment name ( to tagged )" 
	type		= string
}

variable "azs" {
	description	= "List of Availability Zones (AZs)"
	type		= list(string)
}

variable "public_subnets" {
	description	= "List of IPs for Public Subnets"
	type		= list(string)
}

variable "private_subnets" {
	description	= "List of IPs for Private Subnets"
	type		= list(string)
}


