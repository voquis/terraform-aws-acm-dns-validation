# ---------------------------------------------------------------------------------------------------------------------
# Required variables
# ---------------------------------------------------------------------------------------------------------------------

variable "zone_id" {
  description = "Route 53 hosted zone id for domain"
  type        = string
}

variable "domain_name" {
  description = "Domain name for which ACM public certificate is being requestion, may be wildcard"
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional variables
# ---------------------------------------------------------------------------------------------------------------------

variable "ttl" {
  description = "Time to live (ttl) for CNAME DNS validation record"
  type        = number
  default     = 60
}
