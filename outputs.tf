output "acm_certificate" {
  value = aws_acm_certificate.this
}

output "acm_certificate_validation" {
  value = aws_acm_certificate_validation.this
}

output "route53_record" {
  value = aws_route53_record.this
}
