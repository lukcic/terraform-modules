resource "aws_route53_record" "runner" {
  type            = "A"
  ttl             = 300
  allow_overwrite = true
  name            = var.dns_record_name 
  zone_id         = var.dns_zone_id
  records         = [aws_instance.runner-instance.private_ip]
}