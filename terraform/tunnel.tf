locals {
  domain = "yukulab.net"
  tunnel_ingress = {
    hermes = "http://hermes-yukulab.yukulab.svc.cluster.local:8080"
  }

  access_protected_hostnames = ["hermes"]
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "yukulab" {
  account_id = var.cloudflare_account_id
  name       = var.tunnel_name
  config_src = "cloudflare"
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "yukulab" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.yukulab.id

  config = {
    ingress = concat(
      [
        for name, service in local.tunnel_ingress : {
          hostname = "${name}.${local.domain}"
          service  = service
          origin_request = {
            access = {
              aud_tag   = [cloudflare_zero_trust_access_application.hermes.aud]
              team_name = var.team_name
              required  = true
            }
          }
        }
      ],
      [{ service = "http_status:404" }]
    )
  }
}

resource "cloudflare_dns_record" "hermes" {
  zone_id = var.cloudflare_zone_id
  name    = "hermes"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.yukulab.id}.cfargotunnel.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

data "cloudflare_zero_trust_tunnel_cloudflared_token" "yukulab" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.yukulab.id
}
