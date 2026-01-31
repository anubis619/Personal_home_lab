########################
# Jellyseerr (requests)
########################

# Pull image
resource "docker_image" "jellyseerr" {
  name = var.jellyseerr_image
}

# Make sure the config directory exists
resource "null_resource" "jellyseerr_ensure_path" {
  provisioner "local-exec" {
    command = "mkdir -p ${var.config_dir}/jellyseerr"
  }
}

# Run container
resource "docker_container" "jellyseerr" {
  name       = "jellyseerr"
  image      = docker_image.jellyseerr.image_id
  restart    = "unless-stopped"
  depends_on = [docker_network.media_net, null_resource.jellyseerr_ensure_path]

  # Join your shared media network so it can talk to Sonarr/Radarr/Jellyfin by name
  networks_advanced {
    name = docker_network.media_net.name
  }

  # Web UI
  ports {
    internal = 5055
    external = var.jellyseerr_port
    protocol = "tcp"
  }

  # Config
  mounts {
    target = "/app/config"
    source = "${var.config_dir}/jellyseerr"
    type   = "bind"
  }

  # (Optional) Add more env as you like: LOG_LEVEL=debug, etc.
  env = [
    "TZ=${var.tz}",
    "LOG_LEVEL=info",
  ]
}

# Convenience output after apply
output "jellyseerr_url" {
  value       = "http://localhost:${var.jellyseerr_port}"
  description = "Open Jellyseerr web UI"
}
