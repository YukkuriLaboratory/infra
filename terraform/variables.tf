variable "cloudflare_account_id" {
  description = "Cloudflare Account ID"
  type        = string
}

variable "cloudflare_api_token" {
  description = "Cloudflare API Token (provide via TF_VAR_cloudflare_api_token)"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID for yukulab.net"
  type        = string
}

variable "cloudflare_access_policy_id" {
  description = "Cloudflare Zero Trust reusable access policy ID"
  type        = string
}

variable "state_encryption_passphrase" {
  description = "Passphrase for state encryption (provide via TF_VAR_state_encryption_passphrase)"
  type        = string
  sensitive   = true
}

variable "tunnel_name" {
  description = "Cloudflare Tunnel name"
  type        = string
  default     = "yukulab"
}

variable "team_name" {
  description = "Cloudflare Zero Trust team name"
  type        = string
  default     = "yukulab-net"
}

variable "allowed_email_domain" {
  description = "Email domain allowed for CF Access (empty = any email via OTP)"
  type        = string
  default     = "*"
}
