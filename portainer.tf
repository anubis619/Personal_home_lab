# ---------------- Portainer CE ----------------
# Default: UI on 9443 (HTTPS), optional Edge tunnel on 8000
# Ref: https://docs.portainer.io/start/install-ce/server/docker/linux :contentReference[oaicite:3]{index=3}

resource "docker_image" "portainer" {
  name = "portainer/portainer-ce:latest"
}

resource "docker_container" "portainer" {
  depends_on = [
    null_resource.ensure_paths,
    docker_network.media_net
  ]

  name    = "portainer"
  image   = docker_image.portainer.image_id
  restart = "unless-stopped"

  # Portainer needs access to the Docker API socket
  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }

  # Persist Portainer data
  volumes {
    host_path      = var.portainer_data_dir
    container_path = "/data"
  }

  # HTTPS UI
  ports {
    internal = 9443
    external = var.portainer_port
  }

  # Optional Edge tunnel (only needed if you plan to use Edge agents)
  dynamic "ports" {
    for_each = var.portainer_enable_edge_tunnel ? [1] : []
    content {
      internal = 8000
      external = var.portainer_edge_tunnel_port
    }
  }

  networks_advanced {
    name = docker_network.media_net.name
  }
}
