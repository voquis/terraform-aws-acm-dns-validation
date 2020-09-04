ACM DNS Validation
===
Terraform 0.12+ module to provision AWS Certificate Manager (ACM) public certificate using DNS validation.
This module will create a CNAME DNS record in the specified hosted zone for validation.
WIldcard certificates may be issued.
Create

Creates the following resources:
- ACM Certificate
- ACM Certificate Validation request
- Route 53 CNAME DNS record for validation request

# Exmaples
## Existing hosted zone wildcard
```terraform
data "aws_route53_zone" "selected" {
  name = "my.example.com."
}

module "wildcard_example_com" {
  source  = "voquis/acm-dns-validation/aws"
  version = "0.0.1"
  zone_id = data.aws_route53_zone.selected.id
  domain_name = "*.my.example.com"
}
```
### New hosted zone
```terraform
resource "aws_route53_zone" "example_com" {
  name          = "example_com"
  force_destroy = false
}

module "wildcard_example_com" {
  source      = "voquis/acm-dns-validation/aws"
  version     = "0.0.1"
  zone_id     = aws_route53_zone.example_com.id
  domain_name = "example.com"
}
```
