locals {
  # Combine the SAN domains with the primary domain
  domains = concat([{ name = var.domain_name, zone_id = var.zone_id }], var.subject_alternative_names)

  # flatten the 3 nested domain validation details per SAN and primary domain
  domain_validations = flatten([
    for san_domain_key, san_domain in local.domains : [
      for dvo in aws_acm_certificate.this.domain_validation_options : {
        san_domain_key = san_domain_key
        dvo_key        = dvo.resource_record_name
        zone_id        = san_domain.zone_id
        name           = dvo.resource_record_name
        record         = dvo.resource_record_value
        type           = dvo.resource_record_type
      }
    ]
  ])
}
