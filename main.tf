terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.4.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Shared network so containers can reach each other by name
resource "docker_network" "media_net" {
  name = "media-net"
}