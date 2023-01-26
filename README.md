ACM DNS Validation
===
Terraform 0.12+ module to provision AWS Certificate Manager (ACM) public certificate using DNS validation.
This module will create a CNAME DNS record in the specified hosted zone for validation.
WIldcard certificates may be issued.
An optional list of subject alternative names (SANs) may be provided to append to the certificate.
SANs domains may be completely different to the primary domain, each SAN must specify its zone ID.

Creates the following resources:
- ACM Certificate
- ACM Certificate Validation request
- Route 53 CNAME DNS record for validation request

# Examples
## Existing hosted zone wildcard
```terraform
data "aws_route53_zone" "selected" {
  name = "my.example.com."
}

module "wildcard_example_com" {
  source  = "voquis/acm-dns-validation/aws"
  version = "0.1.0"

  zone_id                   = data.aws_route53_zone.selected.id
  domain_name               = "*.my.example.com"
  subject_alternative_names = [
    {
      name    = "www.my.example.com"
      zone_id = data.aws_route53_zone.selected.id
    }
  ]
}
```
## New hosted zone
```terraform
resource "aws_route53_zone" "example_com" {
  name          = "example_com"
  force_destroy = false
}

module "wildcard_example_com" {
  source  = "voquis/acm-dns-validation/aws"
  version = "0.1.0"

  zone_id     = aws_route53_zone.example_com.id
  domain_name = "example.com"
}
```

## SANs across multiple domains
This examples shows how a single certificate can be used for a primary domain and multiple other SANs on completely different domains.
```terraform
data "aws_route53_zone" "example_com" {
  name = "my.example.com"
}

data "aws_route53_zone" "example_net" {
  name = "my.example.net"
}

data "aws_route53_zone" "example_io" {
  name = "my.example.io"
}

module "multiple_sans" {
  source  = "voquis/acm-dns-validation/aws"
  version = "0.1.0"

  zone_id                   = data.aws_route53_zone.example_com.id
  domain_name               = "my.example.com"
  subject_alternative_names = [
    {
      name    = "abc.my.example.net"
      zone_id = data.aws_route53_zone.example_net.id
    },
    {
      name    = "xyz.my.example.io"
      zone_id = data.aws_route53_zone.example_io.id
    },
  ]
}
```


## Different region
To create the certificate in a region that is different to the default provider, pass a provider alias.
This is useful when for example, running an aliased CloudFront distribution, for which the certificate must be located in the US East 1 region, but the S3 bucket is in EU West 2.
```terraform
# Create a new aliased provider
provider "aws" {
  alias  = "useast1"
  region = "us-east-1"
}

module "wildcard_example_com_useast1" {
  source  = "voquis/acm-dns-validation/aws"
  version = "0.1.0"

  providers   = {
    aws = aws.useast1
  }
  zone_id     = aws_route53_zone.example_com.id
  domain_name = "example.com"
}
```
