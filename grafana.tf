# ---------------- Grafana ----------------
resource "docker_image" "grafana" {
  name = var.grafana_image
}

resource "docker_container" "grafana" {
  depends_on = [null_resource.ensure_paths, docker_network.media_net]

  name    = "grafana"
  image   = docker_image.grafana.image_id
  restart = "unless-stopped"

  # Grafana runs as its own user inside container; best to avoid permission pain:
  # ensure host dir is writable by the container user OR run with user = "0"
  # We'll keep it clean and let you chown the dir to match (recommended).
  env = [
    "TZ=${var.tz}",
    "GF_SECURITY_ADMIN_USER=${var.grafana_admin_user}",
    "GF_SECURITY_ADMIN_PASSWORD=${var.grafana_admin_password}"
  ]

  ports {
    internal = 3000
    external = var.grafana_port
    protocol = "tcp"
  }

  mounts {
    target = "/var/lib/grafana"
    source = var.grafana_data_dir
    type   = "bind"
  }

  networks_advanced {
    name = docker_network.media_net.name
  }
}
