############################################
# Homepage Dashboard
############################################

resource "docker_image" "homepage" {
  name = var.homepage_image
}

resource "docker_container" "homepage" {
  depends_on = [
    null_resource.ensure_paths,
    docker_network.media_net
  ]

  name    = "homepage"
  image   = docker_image.homepage.image_id
  restart = "unless-stopped"

  ##########################################
  # Environment variables
  ##########################################
  env = [
    "PUID=${var.puid}",
    "PGID=${var.pgid}",
    "TZ=${var.tz}",

    # Allow access via LAN + local browser
    "HOMEPAGE_ALLOWED_HOSTS=192.168.1.118:${var.homepage_port},localhost:${var.homepage_port},127.0.0.1:${var.homepage_port}"
  ]

  ##########################################
  # Port mapping
  ##########################################
  ports {
    internal = 3000
    external = var.homepage_port
    protocol = "tcp"
  }

  ##########################################
  # Persistent config
  ##########################################
  mounts {
    target = "/app/config"
    source = var.homepage_config_dir
    type   = "bind"
  }

  ##########################################
  # Network
  ##########################################
  networks_advanced {
    name = docker_network.media_net.name
  }
}
