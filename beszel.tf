# ---------------- Beszel (Hub + optional local Agent) ----------------
# Hub default port: 8090
# Docs: https://beszel.dev/guide/hub-installation
# Agent docs: https://beszel.dev/guide/agent-installation

resource "docker_image" "beszel" {
  name = "henrygd/beszel:latest"
}

resource "docker_image" "beszel_agent" {
  name = "henrygd/beszel-agent:latest"
}

resource "docker_container" "beszel" {
  depends_on = [
    null_resource.ensure_paths,
    docker_network.media_net
  ]

  name    = "beszel"
  image   = docker_image.beszel.image_id
  restart = "unless-stopped"

  ports {
    internal = 8090
    external = var.beszel_port
  }

  volumes {
    host_path      = var.beszel_data_dir
    container_path = "/beszel_data"
  }

  # Needed if you run the local agent via unix socket path
  volumes {
    host_path      = var.beszel_socket_dir
    container_path = "/beszel_socket"
  }

  networks_advanced {
    name = docker_network.media_net.name
  }
}

# Optional: local agent on the same host (recommended toggle)
resource "docker_container" "beszel_agent" {
  count = var.beszel_deploy_agent ? 1 : 0

  depends_on = [
    null_resource.ensure_paths,
    docker_container.beszel
  ]

  name    = "beszel-agent"
  image   = docker_image.beszel_agent.image_id
  restart = "unless-stopped"

  # Agent uses host network mode to read host NIC stats (recommended by Beszel)
  network_mode = "host"

  # Persist agent data
  volumes {
    host_path      = var.beszel_agent_data_dir
    container_path = "/var/lib/beszel-agent"
  }

  # Unix socket shared with hub (so hub can connect using /beszel_socket/beszel.sock)
  volumes {
    host_path      = var.beszel_socket_dir
    container_path = "/beszel_socket"
  }

  # Docker stats
  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
    read_only      = true
  }

  env = [
    # Listen on a unix socket (avoids exposing agent TCP port)
    "LISTEN=/beszel_socket/beszel.sock",

    # Hub is exposed on host port 8090 (or var.beszel_port), so host-network agent can reach it via localhost
    "HUB_URL=http://127.0.0.1:${var.beszel_port}",

    # You must set these from the hub UI (tokens/keys) before enabling the agent in Terraform
    "TOKEN=${var.beszel_agent_token}",
    "KEY=${var.beszel_agent_key}",
  ]
}
