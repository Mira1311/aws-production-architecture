module "vpc" {
	source = "../../modules/vpc"

	#Parameter passing into the constructor
	vpc_name	= "core-network"
	environment	= "staging"
	vpc_cidr_block	= "10.0.0.0/16"

	#Array available AZs
	azs		= ["ap-southeast-1a", "ap-southeast-1b"]

	#Array available IP for Public Subnets
	public_subnets	= ["10.0.1.0/24", "10.0.2.0/24"]

	#Array available IP for Private Subnets
	private_subnets	= ["10.0.10.0/24", "10.0.11.0/24"]
}
