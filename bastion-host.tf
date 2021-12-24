# Create Bastion Host Security Group
resource "aws_security_group" "dfsc_bastion_sg" {
  name   = "Bastion Security Group"
  vpc_id = aws_vpc.dfsc_vpc.id
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  tags = {
    Name      = "DFSC Bastion Security Group"
    Terraform = "true"
  }
}

resource "aws_instance" "dfsc_bastion_host-1a" {
  ami                         = "ami-0b4b2d87bdd32212a"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.dfsc_bastion_sg.id]
  subnet_id                   = aws_subnet.dfsc-public-1a.id
  tags = {
    Name      = "DFSC Bastion Host - 1A"
    Terraform = true
  }
}

# CREATE BASTION HOST IN EU-WEST-1B PUBLIC SUBNET
resource "aws_instance" "dfsc_bastion_host-1b" {
  ami                         = "ami-0b4b2d87bdd32212a"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.dfsc_bastion_sg.id]
  subnet_id                   = aws_subnet.dfsc-public-1b.id
  tags = {
    Name      = "DFSC Bastion Host - 1B"
    Terraform = true
  }
}
