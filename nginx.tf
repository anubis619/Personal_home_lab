############################################
# nginx.tf — Nginx Proxy Manager (NPM)
############################################

resource "docker_image" "npm" {
  name         = var.npm_image
  keep_locally = true
}

resource "docker_container" "npm" {
  name    = "nginx-proxy-manager"
  image   = docker_image.npm.image_id
  restart = "unless-stopped"

  networks_advanced {
    name = docker_network.media_net.name
  }

  env = [
    "TZ=${var.tz}",
  ]

  volumes {
    host_path      = "${var.npm_data_dir}/data"
    container_path = "/data"
  }

  volumes {
    host_path      = "${var.npm_data_dir}/letsencrypt"
    container_path = "/etc/letsencrypt"
  }

  # Public HTTP
  ports {
    internal = 80
    external = var.npm_http_port
    protocol = "tcp"
  }

  # Admin UI
  ports {
    internal = 81
    external = var.npm_admin_port
    protocol = "tcp"
  }

  # Public HTTPS
  ports {
    internal = 443
    external = var.npm_https_port
    protocol = "tcp"
  }

  depends_on = [null_resource.ensure_paths]
}

output "npm_ui" {
  value = "http://<server-ip>:${var.npm_admin_port}"
}
