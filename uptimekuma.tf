# ---------------- Uptime Kuma ----------------
# Default UI port: 3001
# Ref: https://hub.docker.com/r/louislam/uptime-kuma :contentReference[oaicite:2]{index=2}

resource "docker_image" "uptime_kuma" {
  name = "louislam/uptime-kuma:2"
}

resource "docker_container" "uptime_kuma" {
  depends_on = [
    null_resource.ensure_paths,
    docker_network.media_net
  ]

  name    = "uptime-kuma"
  image   = docker_image.uptime_kuma.image_id
  restart = "unless-stopped"

  env = [
    "TZ=${var.tz}",
  ]

  ports {
    internal = 3001
    external = var.uptimekuma_port
  }

  volumes {
    host_path      = var.uptimekuma_data_dir
    container_path = "/app/data"
  }

  networks_advanced {
    name = docker_network.media_net.name
  }
}
