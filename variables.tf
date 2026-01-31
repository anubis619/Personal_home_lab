############################
# Base / Host settings
############################

variable "puid" {
  description = "Host user ID used by LinuxServer containers (and used for chown in bootstrap)."
  type        = string
  default     = "1000"
}

variable "pgid" {
  description = "Host group ID used by LinuxServer containers (and used for chown in bootstrap)."
  type        = string
  default     = "1000"
}

variable "tz" {
  description = "Timezone passed to containers."
  type        = string
  default     = "Europe/Zurich"
}

variable "ensure_chown" {
  description = "If true, bootstrap will chown created dirs to PUID:PGID."
  type        = bool
  default     = true
}

############################
# Jellyfin + Media
############################

variable "config_dir" {
  description = "Jellyfin config directory on host."
  type        = string
  default     = "/srv/jellyfin/config"
}

variable "cache_dir" {
  description = "Jellyfin cache directory on host."
  type        = string
  default     = "/srv/jellyfin/cache"
}

variable "movies_dir" {
  description = "Movies library path on host."
  type        = string
  default     = "/mnt/mydrive/Media/Movies"
}

variable "tv_dir" {
  description = "TV library path on host."
  type        = string
  default     = "/mnt/mydrive/Media/TV Shows"
}

variable "downloads_dir" {
  description = "Downloads path on host (qBittorrent target)."
  type        = string
  default     = "/mnt/mydrive/Downloads"
}

variable "jellyfin_image" {
  description = "Jellyfin container image."
  type        = string
  default     = "lscr.io/linuxserver/jellyfin:latest"
}

############################
# *arr stack
############################

variable "bazarr_image" {
  description = "Bazarr container image."
  type        = string
  default     = "lscr.io/linuxserver/bazarr:latest"
}

variable "radarr_image" {
  description = "Radarr container image."
  type        = string
  default     = "lscr.io/linuxserver/radarr:latest"
}

variable "sonarr_image" {
  description = "Sonarr container image."
  type        = string
  default     = "lscr.io/linuxserver/sonarr:latest"
}

variable "qbittorrent_image" {
  description = "qBittorrent container image."
  type        = string
  default     = "lscr.io/linuxserver/qbittorrent:latest"
}

variable "bazarr_config_dir" {
  description = "Bazarr config directory on host."
  type        = string
  default     = "/srv/bazarr/config"
}

variable "radarr_config_dir" {
  description = "Radarr config directory on host."
  type        = string
  default     = "/srv/radarr/config"
}

variable "sonarr_config_dir" {
  description = "Sonarr config directory on host."
  type        = string
  default     = "/srv/sonarr/config"
}

variable "qbittorrent_config_dir" {
  description = "qBittorrent config directory on host."
  type        = string
  default     = "/srv/qbittorrent/config"
}

############################
# Jellyseerr
############################

variable "jellyseerr_image" {
  description = "Container image for Jellyseerr."
  type        = string
  default     = "ghcr.io/fallenbagel/jellyseerr:latest"
}

variable "jellyseerr_port" {
  description = "Host port for Jellyseerr UI."
  type        = number
  default     = 5055
}

############################
# Homepage
############################

variable "homepage_image" {
  description = "Homepage dashboard image."
  type        = string
  default     = "ghcr.io/gethomepage/homepage:latest"
}

variable "homepage_port" {
  description = "Host port for Homepage."
  type        = number
  default     = 3000
}

variable "homepage_config_dir" {
  description = "Homepage config directory on host."
  type        = string
  default     = "/srv/homepage/config"
}

############################
# Homarr
############################

variable "homarr_image" {
  description = "Homarr dashboard image."
  type        = string
  default     = "ghcr.io/homarr-labs/homarr:latest"
}

variable "homarr_port" {
  description = "Host port for Homarr."
  type        = number
  default     = 7575
}

variable "homarr_data_dir" {
  description = "Homarr data directory on host."
  type        = string
  default     = "/srv/homarr/data"
}

# NOTE: no default by design (good security). You MUST provide this in terraform.tfvars.
variable "homarr_secret_encryption_key" {
  description = "Homarr SECRET_ENCRYPTION_KEY (64 hex chars). Do not change after first run."
  type        = string
  sensitive   = true

  validation {
    condition     = can(regex("^[0-9a-f]{64}$", var.homarr_secret_encryption_key))
    error_message = "homarr_secret_encryption_key must be exactly 64 lowercase hex characters (use: openssl rand -hex 32)."
  }
}

############################
# Grafana
############################

variable "grafana_image" {
  description = "Grafana OSS image."
  type        = string
  default     = "grafana/grafana-oss:latest"
}

variable "grafana_port" {
  description = "Host port for Grafana."
  type        = number
  default     = 3002
}

variable "grafana_data_dir" {
  description = "Grafana data directory on host."
  type        = string
  default     = "/srv/grafana/data"
}

variable "grafana_admin_user" {
  description = "Grafana admin username."
  type        = string
  default     = "admin"
}

variable "grafana_admin_password" {
  description = "Grafana admin password."
  type        = string
  default     = "admin"
  sensitive   = true
}

############################
# Wazuh (single-node)
############################

variable "wazuh_version" {
  description = "Wazuh stack version tag (manager/indexer/dashboard). Use a published tag, not 'latest'."
  type        = string
  default     = "4.14.2"
}

variable "wazuh_cert_ip" {
  description = "IP or DNS name to embed in cert SAN entries. MUST be a real IP/FQDN (not docker name)."
  type        = string
  default     = "192.168.1.118"
}

# Optional overrides (kept for flexibility)
variable "wazuh_manager_image" {
  description = "Wazuh manager image (optional override)."
  type        = string
  default     = "wazuh/wazuh-manager:latest"
}

variable "wazuh_indexer_image" {
  description = "Wazuh indexer image (optional override)."
  type        = string
  default     = "wazuh/wazuh-indexer:latest"
}

variable "wazuh_dashboard_image" {
  description = "Wazuh dashboard image (optional override)."
  type        = string
  default     = "wazuh/wazuh-dashboard:latest"
}

variable "wazuh_dashboard_port" {
  description = "Host port for Wazuh dashboard."
  type        = number
  default     = 5601
}

variable "wazuh_manager_api_port" {
  description = "Host port for Wazuh manager API."
  type        = number
  default     = 55000
}

variable "wazuh_indexer_port" {
  description = "Host port for Wazuh indexer."
  type        = number
  default     = 9200
}

variable "wazuh_manager_data_dir" {
  description = "Wazuh manager data directory on host."
  type        = string
  default     = "/srv/wazuh/manager"
}

variable "wazuh_indexer_data_dir" {
  description = "Wazuh indexer data directory on host."
  type        = string
  default     = "/srv/wazuh/indexer"
}

variable "wazuh_dashboard_config_dir" {
  description = "Host directory for Wazuh dashboard config (opensearch_dashboards.yml is generated here)."
  type        = string
  default     = "/srv/wazuh/dashboard/config"
}

variable "wazuh_host_config_dir" {
  description = "Host directory for extra Wazuh artifacts (certs.yml input, etc.)."
  type        = string
  default     = "/srv/wazuh/config"
}

variable "wazuh_certs_dir" {
  description = "Host directory where certs are generated/stored."
  type        = string
  default     = "/srv/wazuh/certs"
}

variable "wazuh_certs_generator_version" {
  description = "wazuh-certs-generator image tag."
  type        = string
  default     = "0.0.3"
}

variable "wazuh_indexer_scheme" {
  description = "Protocol used by components to talk to the Wazuh indexer (https recommended)."
  type        = string
  default     = "https"

  validation {
    condition     = contains(["http", "https"], var.wazuh_indexer_scheme)
    error_message = "wazuh_indexer_scheme must be 'http' or 'https'."
  }
}

# Credentials used between Wazuh components
variable "wazuh_dashboard_indexer_username" {
  description = "OpenSearch username used by Wazuh dashboard to connect to indexer."
  type        = string
  default     = "admin"
}

variable "wazuh_dashboard_indexer_password" {
  description = "OpenSearch password used by Wazuh dashboard to connect to indexer."
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "wazuh_manager_indexer_username" {
  description = "OpenSearch username used by Wazuh manager to connect to indexer."
  type        = string
  default     = "admin"
}

variable "wazuh_manager_indexer_password" {
  description = "OpenSearch password used by Wazuh manager to connect to indexer."
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "wazuh_dashboard_username" {
  description = "Internal Wazuh dashboard user (often kibanaserver)."
  type        = string
  default     = "kibanaserver"
}

variable "wazuh_dashboard_password" {
  description = "Internal Wazuh dashboard password (often kibanaserver)."
  type        = string
  default     = "kibanaserver"
  sensitive   = true
}
