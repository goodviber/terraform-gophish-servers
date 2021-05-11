resource "cloudflare_record" "www" {
  count = var.CLOUDFLARE_RESOURCES ? 1 : 0
  zone_id = var.zone_id
  name = "mail"
  value = aws_instance.aws_server[0].public_ip
  type = "A"
  proxied = false
}

resource "cloudflare_record" "mx" {
  count = var.CLOUDFLARE_RESOURCES ? 1 : 0
  zone_id = var.zone_id
  name = "mail"
  value = "mail.your_domain_here.net"
  priority = 0
  type = "MX"
  proxied = false
}
