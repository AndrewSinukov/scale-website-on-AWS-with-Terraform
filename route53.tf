resource "aws_route53_record" "www_record" {
  name    = "www.demofirstshop.com"
  type    = "A"
  zone_id = "Z0306500593NFEEY7WFD"
  alias {
    evaluate_target_health = false
    name                   = aws_alb.dfsc_alb.dns_name
    zone_id                = aws_alb.dfsc_alb.zone_id
  }
}

resource "aws_route53_record" "cdn_record" {
  name    = "cdn.demofirstshop.com"
  type    = "A"
  zone_id = "Z0306500593NFEEY7WFD"
  alias {
    evaluate_target_health = false
    name                   = aws_alb.dfsc_alb.dns_name
    zone_id                = aws_alb.dfsc_alb.zone_id
  }
}
