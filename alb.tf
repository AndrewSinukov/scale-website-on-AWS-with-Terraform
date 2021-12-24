resource "aws_security_group" "dfsc_alb_sg" {
  name   = "ALB Security Group"
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
    from_port = 443
    protocol  = "tcp"
    to_port   = 443
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  tags = {
    Name      = "DFSC ALB Security Group"
    Terraform = "True"
  }
}

resource "aws_alb" "dfsc_alb" {
  name               = "dfsc-app-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.dfsc_alb_sg.id]
  subnets = [
    aws_subnet.dfsc_public_1a.id,
    aws_subnet.dfsc_public_1b.id
  ]
  enable_deletion_protection = false
  tags = {
    Name      = "Dfsc Application Load Balancer"
    Terraform = "True"
  }
}
