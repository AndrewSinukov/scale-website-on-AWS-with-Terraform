# Create a public route table for Public Subnets
resource "aws_route_table" "dfsc_public" {
  vpc_id = aws_vpc.dfsc_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dfsc_igw.id
  }
  tags = {
    Name      = "DFSC Public Route Table"
    Terraform = "true"
  }
}

# Attach a public route table to Public Subnets
resource "aws_route_table_association" "dfsc_public_1a_association" {
  subnet_id      = aws_subnet.dfsc_public_1a.id
  route_table_id = aws_route_table.dfsc_public.id
}

resource "aws_route_table_association" "dfsc_public_1b_association" {
  subnet_id      = aws_subnet.dfsc_public_1b.id
  route_table_id = aws_route_table.dfsc_public.id
}
