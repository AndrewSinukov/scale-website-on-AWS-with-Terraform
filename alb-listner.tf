resource "aws_lb_listener" "dfsc_https" {
  load_balancer_arn = aws_alb.dfsc_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-0-2015-04"
  certificate_arn   = "arn:aws:eu-west-1:497415687145:certificate/0e604fcd-22b2-4b18-a284-882b082b37d5"
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.dfsc_front_end_tg.arn
  }
}

resource "aws_lb_listener_rule" "dfsc_admin_https" {
  listener_arn = aws_alb.dfsc_alb.arn
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.dfsc_back-end-tg.arn
  }
  condition {
    path_pattern {
      values = ["/admin*"]
    }
  }
}
