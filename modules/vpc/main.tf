resource "aws_vpc" "this" {
	#1, Passing parameter from variable into CIDR block
	cidr_block = var.vpc_cidr_block

	#2, Enable DNS (must) to running Database and Load Balance on real production
	enable_dns_support = true
	enable_dns_hostnames = true

	#3, Auto tagging
	tags = {
		Name		= "${var.vpc_name}-${var.environment}"
		Environment	= var.environment
	}
}
#4, setup subnet for public
resource "aws_subnet" "public" {
	count			= length(var.public_subnets)
	vpc_id			= aws_vpc.this.id
	cidr_block		= var.public_subnets[count.index]
	availability_zone	= var.azs[count.index]
	map_public_ip_on_launch	= true

	tags = {
		Name		= "${var.vpc_name}-public-${var.azs[count.index]}"
		Environment	= var.environment
	}
}
#5, Setup subnet for private
resource "aws_subnet" "private" {
	count			= length(var.private_subnets)
	vpc_id			= aws_vpc.this.id
	cidr_block		= var.private_subnets[count.index]
	availability_zone	= var.azs[count.index]

	tags = {
		Name		= "${var.vpc_name}-private-${var.azs[count.index]}"
		Environment	= var.environment
	}
}
#6, Build an IGW
resource "aws_internet_gateway" "this" {
	vpc_id = aws_vpc.this.id
	tags = {
		Name		= "$var.vpc_name}-igw"
		Environment	= var.environment
	}
}
#7, Draw a public route table for public IPs
resource "aws_route_table" "public" {
	vpc_id = aws_vpc.this.id
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.this.id
	}
	tags = {
		Name		= "${var.vpc_name}-public-rt"
		Environment	= var.environment
	}
}
#8, Give the route table map to 2 Public IPs (Route Table Association)
resource "aws_route_table_association" "public" {
	count			= length(var.public_subnets)
	subnet_id		= aws_subnet.public[count.index].id
	route_table_id		= aws_route_table.public.id
}

#9, Setup an elastic IP for NAT
resource "aws_eip" "nat" {
	domain	= "vpc"
	tags = {
		Name		= "${var.vpc_name}-nat-eip"
		Environment	= var.environment
	}
}

#10, Bring NAT Gateway and setup for it
resource "aws_nat_gateway" "this" {
	allocation_id	= aws_eip.nat.id
	subnet_id	= aws_subnet.public[0].id 

	tags = {
		Name		= "${var.vpc_name}-nat"
		Environment	= var.environment
	}
	depends_on = [aws_internet_gateway.this]
}

#11, Create a roadmap for Private Route Table
resource "aws_route_table" "private" {
	vpc_id = aws_vpc.this.id
	
	#New rule for NAT: If want to get internet while in Private Network, get a route for NAT gateway
	route {
		cidr_block		= "0.0.0.0/0"
		nat_gateway_id		= aws_nat_gateway.this.id
	}

	tags = {
		Name		= "${var.vpc_name}-private-rt"
		Environment	= var.environment
	}
}

#12, Give the roadmap to 2 private subnets 
resource "aws_route_table_association" "private" {
	count		= length(var.private_subnets)
	subnet_id	= aws_subnet.private[count.index].id
	route_table_id	= aws_route_table.private.id
}











