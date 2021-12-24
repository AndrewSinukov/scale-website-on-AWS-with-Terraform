resource "aws_security_group" "dfsc_asg_sg" {
  name   = "ASG Security Group"
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
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
    cidr_blocks = [
      aws_security_group.dfsc_alb_sg.id
    ]
  }
  ingress {
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    cidr_blocks = [
      aws_security_group.dfsc_bastion_sg.id
    ]
  }
  tags = {
    Name      = "Dfsc ASG Security Group"
    Terraform = "True"
  }
}

data "template_file" "userdata_template" {
  template = file("user-data.tpl")
  vars = {
    db_host      = aws_db_instance.dfsc_db.address
    db_username  = aws_db_instance.dfsc_db.username
    db_password  = aws_db_instance.dfsc_db.password
    db_name      = aws_db_instance.dfsc_db.name
    cache_host   = aws_elasticache_replication_group.dfsc_elasticache.primary_endpoint_address
    efs_endpoint = aws_efs_file_system.dfsc_efs.dns_name
  }
}

resource "aws_launch_configuration" "dfsc_launch_config" {
  name_prefix     = "DFSC Launch Configuration"
  image_id        = "ami-of2ed58082cb08a4d"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.dfsc_asg_sg.id]
  user_data       = data.template_file.userdata_template.rendered
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "dfsc_front_end" {
  name                 = "DFSC FrontEnd ASG"
  launch_configuration = aws_launch_configuration.dfsc_launch_config.name
  health_check_type    = "ELB"
  max_size             = 0
  min_size             = 0
  desired_capacity     = 0

  vpc_zone_identifier = [
    aws_subnet.dfsc_public_1a.id,
    aws_subnet.dfsc_public_1b.id
  ]
  target_group_arns = [aws_alb_target_group.dfsc_front_end_tg.arn]
  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "Dfsc FrontEnd ASG"
  }
}

resource "aws_autoscaling_group" "dfsc_back_end" {
  name                 = "DFSC BackEnd ASG"
  launch_configuration = aws_launch_configuration.dfsc_launch_config.name
  health_check_type    = "ELB"
  max_size             = 0
  min_size             = 0
  desired_capacity     = 0

  vpc_zone_identifier = [
    aws_subnet.dfsc_private_1a.id,
    aws_subnet.dfsc_private_1b
  ]
  target_group_arns = [aws_alb_target_group.dfsc_back_end_tg]
  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "Dfsc BackEnd ASG"
  }
}
