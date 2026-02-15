############################################
# macvlan.tf — LAN macvlan for Pi-hole
############################################

resource "docker_network" "pihole_macvlan" {
  name   = "pihole-macvlan"
  driver = "macvlan"

  options = {
    parent = var.lan_interface
  }

  ipam_config {
    subnet  = var.lan_subnet
    gateway = var.lan_gateway
  }
}
