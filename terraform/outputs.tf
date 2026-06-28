output "tunnel_id" {
  description = "Cloudflare Tunnel ID"
  value       = cloudflare_zero_trust_tunnel_cloudflared.yukulab.id
}

output "tunnel_token" {
  description = "Cloudflare Tunnel token for cloudflared K8s secret"
  value       = data.cloudflare_zero_trust_tunnel_cloudflared_token.yukulab.token
  sensitive   = true
}

output "tunnel_cname" {
  description = "Tunnel CNAME target"
  value       = "${cloudflare_zero_trust_tunnel_cloudflared.yukulab.id}.cfargotunnel.com"
}

output "access_application_aud" {
  description = "Access Application AUD tag"
  value       = cloudflare_zero_trust_access_application.hermes.aud
}
