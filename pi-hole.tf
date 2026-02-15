############################################
# pi-hole.tf — Pi-hole on macvlan + media-net
############################################

resource "docker_image" "pihole" {
  name         = var.pihole_image
  keep_locally = true
}

resource "docker_container" "pihole" {
  name    = "pihole"
  image   = docker_image.pihole.image_id
  restart = "unless-stopped"

  # Internal docker network (talk to other containers by name)
  networks_advanced {
    name = docker_network.media_net.name
  }

  # LAN network (macvlan) — Pi-hole gets real LAN IP
  networks_advanced {
    name         = docker_network.pihole_macvlan.name
    ipv4_address = var.pihole_lan_ip
  }

  # NOTE: No "ports" mapping needed with macvlan.
  # DNS: 53/tcp+udp on var.pihole_lan_ip
  # UI:  http://var.pihole_lan_ip/admin

  env = [
    "TZ=${var.tz}",
    "WEBPASSWORD=${var.pihole_webpassword}",
    "DNS1=${var.pihole_dns1}",
    "DNS2=${var.pihole_dns2}",
  ]

  volumes {
    host_path      = "${var.pihole_data_dir}/etc-pihole"
    container_path = "/etc/pihole"
  }

  volumes {
    host_path      = "${var.pihole_data_dir}/etc-dnsmasq.d"
    container_path = "/etc/dnsmasq.d"
  }

  capabilities {
    add = ["NET_ADMIN"]
  }

  depends_on = [null_resource.ensure_paths]
}

output "pihole_ui" {
  value = "http://${var.pihole_lan_ip}/admin"
}
