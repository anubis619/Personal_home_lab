# ---------------- qBittorrent ----------------
resource "docker_image" "qbittorrent" {
  name = var.qbittorrent_image
}

resource "docker_container" "qbittorrent" {
  depends_on = [
    null_resource.ensure_paths,
    null_resource.qbittorrent_preset,
    docker_network.media_net
  ]

  name    = "qbittorrent"
  image   = docker_image.qbittorrent.image_id
  restart = "unless-stopped"

  env = [
    "PUID=${var.puid}",
    "PGID=${var.pgid}",
    "TZ=${var.tz}",
    "WEBUI_PORT=8080"
  ]

  ports {
    internal = 8080
    external = 8080
    protocol = "tcp"
  }

  mounts {
    target = "/config"
    source = var.qbittorrent_config_dir
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

# Helper: show qBittorrent temp password after apply
resource "null_resource" "qbittorrent_password_hint" {
  depends_on = [docker_container.qbittorrent]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
echo "--------------------------------------------"
echo "qBittorrent temporary login (check below):"
docker logs qbittorrent 2>&1 | grep -i "WebUI password" | tail -n 1 || true
echo "--------------------------------------------"
EOT
  }
}
