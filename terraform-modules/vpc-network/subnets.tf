#create public subnets 
resource "aws_subnet" "public_subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.appvpc.id
  cidr_block              = var.public_subnets_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.subnets_az[count.index]

}

#create private subnets
resource "aws_subnet" "private_subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.appvpc.id
  cidr_block              = var.private_subnets_cidr[count.index]
  map_public_ip_on_launch = false
  availability_zone       = var.subnets_az[count.index]

}
