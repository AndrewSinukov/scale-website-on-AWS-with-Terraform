resource "aws_security_group" "dfsc_efs_sg" {
  name   = "DFSC EFS Secutiry Group"
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
    from_port = 2049
    protocol  = "tcp"
    to_port   = 2049
    security_groups = [
      aws_security_group.dfsc_asg_sg.id
    ]
  }
  tags = {
    Name      = "DFSC EFS Security Group"
    Terraform = "True"
  }
}

resource "aws_efs_file_system" "dfsc_efs" {
  creation_token   = "dfsc-elastic-file-system"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  tags = {
    Name      = "DFSC Elastic File System"
    Terraform = "True"
  }
}

resource "aws_efs_mount_target" "dfsc_mount_private_1a" {
  file_system_id = aws_efs_file_system.dfsc_efs.id
  subnet_id      = aws_subnet.dfsc-private-1a.id
  security_groups = [
    aws_security_group.dfsc_efs_sg.id
  ]
}

resource "aws_efs_mount_target" "dfsc_mount_private_1b" {
  file_system_id = aws_efs_file_system.dfsc_efs.id
  subnet_id      = aws_subnet.dfsc-private-1b.id
  security_groups = [
    aws_security_group.dfsc_efs_sg.id
  ]
}
