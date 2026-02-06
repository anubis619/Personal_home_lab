# ---------------- Prowlarr ----------------
# Image/docs:
# - linuxserver/prowlarr container image
# - Default UI port: 9696
# Ref: https://hub.docker.com/r/linuxserver/prowlarr :contentReference[oaicite:1]{index=1}

resource "docker_image" "prowlarr" {
  name = "lscr.io/linuxserver/prowlarr:latest"
}

resource "docker_container" "prowlarr" {
  depends_on = [
    null_resource.ensure_paths,
    docker_network.media_net
  ]

  name    = "prowlarr"
  image   = docker_image.prowlarr.image_id
  restart = "unless-stopped"

  env = [
    "PUID=${var.puid}",
    "PGID=${var.pgid}",
    "TZ=${var.tz}",
  ]

  # UI
  ports {
    internal = 9696
    external = var.prowlarr_port
  }

  # Persist config
  volumes {
    host_path      = var.prowlarr_config_dir
    container_path = "/config"
  }

  networks_advanced {
    name = docker_network.media_net.name
  }
}
