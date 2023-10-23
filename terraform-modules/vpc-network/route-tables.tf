#public subnet route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.appvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}


#public subnet1  assosiation
resource "aws_route_table_association" "public_rt_asso" {
  subnet_id      = aws_subnet.public_subnets[0].id
  route_table_id = aws_route_table.public_rt.id
}



#public subnet2  assosiation
resource "aws_route_table_association" "public_rt_asso2" {
  subnet_id      = aws_subnet.public_subnets[1].id
  route_table_id = aws_route_table.public_rt.id
}

#private subnet route table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.appvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }
}


#private subnet1  assosiation
resource "aws_route_table_association" "private_rt_asso" {
  subnet_id      = aws_subnet.private_subnets[0].id
  route_table_id = aws_route_table.private_rt.id
}


#private subnet2  assosiation
resource "aws_route_table_association" "private_rt_asso2" {
  subnet_id      = aws_subnet.private_subnets[1].id
  route_table_id = aws_route_table.private_rt.id
}