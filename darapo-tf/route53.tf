# Route 53 설정 (도메인 연결용)
data "aws_route53_zone" "selected" {
  count = var.domain_name != "" ? 1 : 0
  name  = var.domain_name
}

# 루트 도메인 A 레코드 (darapo.site)
resource "aws_route53_record" "root" {
  count           = var.domain_name != "" ? 1 : 0
  zone_id         = var.hosted_zone_id != "" ? var.hosted_zone_id : data.aws_route53_zone.selected[0].zone_id
  name            = var.domain_name
  type            = "A"
  ttl             = "300"
  records         = [aws_eip.app.public_ip]
  allow_overwrite = true
}

# API 서브도메인 A 레코드 (api.darapo.site)
resource "aws_route53_record" "api" {
  count           = var.domain_name != "" ? 1 : 0
  zone_id         = var.hosted_zone_id != "" ? var.hosted_zone_id : data.aws_route53_zone.selected[0].zone_id
  name            = "api.${var.domain_name}"
  type            = "A"
  ttl             = "300"
  records         = [aws_eip.app.public_ip]
  allow_overwrite = true
}
