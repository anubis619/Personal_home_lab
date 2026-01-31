# ---------------- Bazarr ----------------
resource "docker_image" "bazarr" {
  name = var.bazarr_image
}

resource "docker_container" "bazarr" {
  depends_on = [null_resource.ensure_paths, docker_network.media_net]

  name    = "bazarr"
  image   = docker_image.bazarr.image_id
  restart = "unless-stopped"

  env = [
    "PUID=${var.puid}",
    "PGID=${var.pgid}",
    "TZ=${var.tz}"
  ]

  ports {
    internal = 6767
    external = 6767
    protocol = "tcp"
  }

  mounts {
    target = "/config"
    source = var.bazarr_config_dir
    type   = "bind"
  }

  mounts {
    target = "/data/movies"
    source = var.movies_dir
    type   = "bind"
  }

  mounts {
    target = "/data/tv"
    source = var.tv_dir
    type   = "bind"
  }

  networks_advanced {
    name = docker_network.media_net.name
  }
}
