# ---------------- Wazuh (single-node) ----------------

resource "docker_image" "wazuh_manager" {
  name = var.wazuh_manager_image
}

resource "docker_image" "wazuh_indexer" {
  name = var.wazuh_indexer_image
}

resource "docker_image" "wazuh_dashboard" {
  name = var.wazuh_dashboard_image
}

# Indexer (OpenSearch-based)
resource "docker_container" "wazuh_indexer" {
  depends_on = [null_resource.ensure_paths, docker_network.media_net]

  name    = "wazuh-indexer"
  image   = docker_image.wazuh_indexer.image_id
  restart = "unless-stopped"

  env = [
    "TZ=${var.tz}",
    "OPENSEARCH_JAVA_OPTS=-Xms1g -Xmx1g",
    "discovery.type=single-node",
    "plugins.security.ssl.http.enabled=false"
  ]

  ports {
    internal = 9200
    external = var.wazuh_indexer_port
    protocol = "tcp"
  }

  mounts {
    target = "/var/lib/wazuh-indexer"
    source = var.wazuh_indexer_data_dir
    type   = "bind"
  }

  networks_advanced {
    name = docker_network.media_net.name
  }
}

# Manager
resource "docker_container" "wazuh_manager" {
  depends_on = [null_resource.ensure_paths, docker_network.media_net, docker_container.wazuh_indexer]

  name    = "wazuh-manager"
  image   = docker_image.wazuh_manager.image_id
  restart = "unless-stopped"

  env = [
    "TZ=${var.tz}",
    # Point manager to indexer
    "INDEXER_URL=http://wazuh-indexer:9200"
  ]

  ports {
    internal = 55000
    external = var.wazuh_manager_api_port
    protocol = "tcp"
  }

  mounts {
    target = "/var/ossec/data"
    source = var.wazuh_manager_data_dir
    type   = "bind"
  }

  networks_advanced {
    name = docker_network.media_net.name
  }
}

# Dashboard
resource "docker_container" "wazuh_dashboard" {
  depends_on = [null_resource.ensure_paths, docker_network.media_net, docker_container.wazuh_manager, docker_container.wazuh_indexer]

  name    = "wazuh-dashboard"
  image   = docker_image.wazuh_dashboard.image_id
  restart = "unless-stopped"

  env = [
    "TZ=${var.tz}",
    "WAZUH_API_URL=http://wazuh-manager:55000",
    "OPENSEARCH_HOSTS=http://wazuh-indexer:9200"
  ]

  ports {
    internal = 5601
    external = var.wazuh_dashboard_port
    protocol = "tcp"
  }

  networks_advanced {
    name = docker_network.media_net.name
  }
}
