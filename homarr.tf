# ---------------- Homarr ----------------
resource "docker_image" "homarr" {
  name = var.homarr_image
}

resource "docker_container" "homarr" {
  depends_on = [null_resource.ensure_paths, docker_network.media_net]

  name    = "homarr"
  image   = docker_image.homarr.image_id
  restart = "unless-stopped"

env = [
  "TZ=${var.tz}",
  "SECRET_ENCRYPTION_KEY=${var.homarr_secret_encryption_key}",
]

  ports {
    internal = 7575
    external = var.homarr_port
    protocol = "tcp"
  }

  mounts {
    target = "/app/data"
    source = var.homarr_data_dir
    type   = "bind"
  }

    # ✅ enable Docker integration
  mounts {
    target = "/var/run/docker.sock"
    source = "/var/run/docker.sock"
    type   = "bind"
  }

  networks_advanced {
    name = docker_network.media_net.name
  }
}
