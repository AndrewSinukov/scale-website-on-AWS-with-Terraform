# CREATE ELASTIC IP ADDRESS FOR NAT GATEWAY
resource "aws_eip" "dfsc_nat1" {
}
resource "aws_eip" "dfsc_nat2" {
}

# CREATE NAT GATEWAY in EU-West-1A
resource "aws_nat_gateway" "dfsc_nat_gateway_1a" {
  allocation_id = aws_eip.dfsc_nat1.id
  subnet_id     = aws_subnet.dfsc_public_1a.id

  tags = {
    Name      = "Nat Gateway-1a"
    Terraform = "True"
  }
}

# CREATE NAT GATEWAY in EU-West-1B
resource "aws_nat_gateway" "dfsc_nat_gateway_1b" {
  allocation_id = aws_eip.dfsc_nat2.id
  subnet_id     = aws_subnet.dfsc_public_1b.id

  tags = {
    Name      = "Nat Gateway-1b"
    Terraform = "True"
  }
}
