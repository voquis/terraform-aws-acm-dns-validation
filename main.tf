# ---------------------------------------------------------------------------------------------------------------------
# ACM public Certificate
# Provider Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_acm_certificate" "this" {
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Certificate validation request
# Provider Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.this : record.fqdn]
}

# ---------------------------------------------------------------------------------------------------------------------
# Route53 record for domain validation request
# Provider Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_route53_record" "this" {
  count = length(var.domain_name)
  allow_overwrite = true
  name = aws_acm_certificate.this.domain_validation_options[count.index].resource_record_name
  records = [aws_acm_certificate.this.domain_validation_options[count.index].resource_record_value]
  ttl = var.ttl
  type = aws_acm_certificate.this.domain_validation_options[count.index].resource_record_type
  zone_id = var.zone_id[count.index]

}
