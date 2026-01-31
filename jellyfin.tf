# ---------------- Jellyfin ----------------
resource "docker_image" "jellyfin" {
  name = var.jellyfin_image
}

resource "docker_container" "jellyfin" {
  depends_on = [null_resource.ensure_paths, docker_network.media_net]

  name    = "jellyfin"
  image   = docker_image.jellyfin.image_id
  restart = "unless-stopped"
  runtime = "nvidia"

  env = [
    "PUID=${var.puid}",
    "PGID=${var.pgid}",
    "TZ=${var.tz}",
    "NVIDIA_VISIBLE_DEVICES=all",
    "NVIDIA_DRIVER_CAPABILITIES=compute,video,utility"
  ]

  ports {
    internal = 8096
    external = 8096
    protocol = "tcp"
  }

  mounts {
    target = "/config"
    source = var.config_dir
    type   = "bind"
  }

  mounts {
    target = "/cache"
    source = var.cache_dir
    type   = "bind"
  }

  mounts {
    target    = "/data/movies"
    source    = var.movies_dir
    type      = "bind"
    read_only = true
  }

  mounts {
    target    = "/data/tv"
    source    = var.tv_dir
    type      = "bind"
    read_only = true
  }

  networks_advanced {
    name = docker_network.media_net.name
  }
}