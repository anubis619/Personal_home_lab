# ---------------- Sonarr (TV) ----------------
resource "docker_image" "sonarr" {
  name = var.sonarr_image
}

resource "docker_container" "sonarr" {
  depends_on = [null_resource.ensure_paths, docker_network.media_net]

  name    = "sonarr"
  image   = docker_image.sonarr.image_id
  restart = "unless-stopped"

  env = [
    "PUID=${var.puid}",
    "PGID=${var.pgid}",
    "TZ=${var.tz}"
  ]

  ports {
    internal = 8989
    external = 8989
    protocol = "tcp"
  }

  mounts {
    target = "/config"
    source = var.sonarr_config_dir
    type   = "bind"
  }

  mounts {
    target = "/data/tv"
    source = var.tv_dir
    type   = "bind"
  }

  mounts {
    target = "/downloads"
    source = var.downloads_dir
    type   = "bind"
  }

  networks_advanced {
    name = docker_network.media_net.name
  }
}

