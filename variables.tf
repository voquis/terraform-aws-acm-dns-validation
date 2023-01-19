# ---------------------------------------------------------------------------------------------------------------------
# Required variables
# ---------------------------------------------------------------------------------------------------------------------

variable "zone_id" {
  description = "Route 53 hosted zone id for domain"
  type        = list(string)
}

variable "domain_name" {
  description = "Domain name for which ACM public certificate is being requestion, may be wildcard"
  type        = list(string)
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional variables
# ---------------------------------------------------------------------------------------------------------------------

variable "ttl" {
  description = "Time to live (ttl) for CNAME DNS validation record"
  type        = number
  default     = 60
}

variable "subject_alternative_names" {
  description = "List of additional domains that should be added to the issued certificate as subject alternative names (SANs)."
  type        = list(string)
  default     = []
}
