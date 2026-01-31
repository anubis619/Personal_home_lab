# ---------------- Radarr (Movies) ----------------
resource "docker_image" "radarr" {
  name = var.radarr_image
}

resource "docker_container" "radarr" {
  depends_on = [null_resource.ensure_paths, docker_network.media_net]

  name    = "radarr"
  image   = docker_image.radarr.image_id
  restart = "unless-stopped"

  env = [
    "PUID=${var.puid}",
    "PGID=${var.pgid}",
    "TZ=${var.tz}"
  ]

  ports {
    internal = 7878
    external = 7878
    protocol = "tcp"
  }

  mounts {
    target = "/config"
    source = var.radarr_config_dir
    type   = "bind"
  }

  mounts {
    target = "/data/movies"
    source = var.movies_dir
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