resource "aws_alb_target_group" "dfsc_front_end_tg" {
  port     = 80
  protocol = "HTTP"
  name     = "dfsc-front-end-tagrget-group"
  vpc_id   = aws_vpc.dfsc_vpc.id
  stickiness {
    type    = "lb_cookie"
    enabled = true
  }
  health_check {
    protocol            = "HTTP"
    path                = "/healthy.html"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
  }
  tags = {
    Name      = "DFSC Front End Target Group"
    Terraform = "true"
  }
}

resource "aws_alb_target_group" "dfsc_back_end_tg" {
  port     = 80
  protocol = "HTTP"
  name     = "dfsc-back-end-target-group"
  vpc_id   = aws_vpc.dfsc_vpc.id
  stickiness {
    type    = "lb_cookie"
    enabled = true
  }
  health_check {
    protocol            = "HTTP"
    path                = "/healthy.html"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
  }
  tags = {
    Name      = "DFSC Back End Target Group"
    Terraform = "true"
  }
}


