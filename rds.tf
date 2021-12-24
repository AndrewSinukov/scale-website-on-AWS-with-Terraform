resource "aws_security_group" "dfsc_db_sg" {
  name   = "DFSC RDS Security Group"
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
    from_port = 3306
    protocol  = "tcp"
    to_port   = 3306
    security_groups = [
      aws_security_group.dfsc_asg_sg.id
    ]
  }
  tags = {
    Name      = "Dfsc RDS Security Group"
    Terraform = "True"
  }
}

resource "aws_db_subnet_group" "dfsc_db_subnet" {
  name = "dfsc-database-subnet-group"
  subnet_ids = [
    aws_subnet.dfsc_private_1a.id,
    aws_subnet.dfsc_private_1b.id
  ]
  tags = {
    Name      = "Dfsc Subnet Group"
    Terraform = "True"
  }
}

# Define VPC Variable
variable "db_master_password" {
  type    = string
  default = "10.0.0.0/16"
}

resource "aws_db_instance" "dfsc_db" {
  allocated_storage       = "10"
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "5.6"
  multi_az                = "true"
  instance_class          = "db.t2.micro"
  name                    = "dfsc"
  username                = "admin"
  password                = var.db_master_password
  identifier              = "dfsc-database"
  skip_final_snapshot     = "true"
  backup_retention_period = "7"
  port                    = "3306"
  storage_encrypted       = "false"
  db_subnet_group_name    = aws_db_subnet_group.dfsc_db_subnet.name
  vpc_security_group_ids = [
    aws_security_group.dfsc_db_sg.id
  ]
  tags = {
    Name      = "Dfsc Database"
    Terraform = "True"
  }
}
