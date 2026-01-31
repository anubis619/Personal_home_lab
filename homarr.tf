# ---------------- Homepage ----------------
resource "docker_image" "homepage" {
  name = var.homepage_image
}

resource "docker_container" "homepage" {
  depends_on = [null_resource.ensure_paths, docker_network.media_net]

  name    = "homepage"
  image   = docker_image.homepage.image_id
  restart = "unless-stopped"

  # Homepage supports PUID/PGID on many setups; safe to include.
  env = [
    "PUID=${var.puid}",
    "PGID=${var.pgid}",
    "TZ=${var.tz}"
  ]

  ports {
    internal = 3000
    external = var.homepage_port
    protocol = "tcp"
  }

  mounts {
    target = "/app/config"
    source = var.homepage_config_dir
    type   = "bind"
  }

  networks_advanced {
    name = docker_network.media_net.name
  }
}
