# ---------------------------------------------------------------------------------------------------------------------
# ACM public Certificate
# Provider Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_acm_certificate" "this" {
  domain_name = var.domain_name
  subject_alternative_names = [
    for s in var.subject_alternative_names : s.name
  ]
  validation_method = "DNS"

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
  for_each = {
    for domain_validation in local.domain_validations : "${domain_validation.san_domain_key}.${domain_validation.dvo_key}" => domain_validation
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = var.ttl
  type            = each.value.type
  zone_id         = each.value.zone_id
}
