variable "puid" {
  type    = string
  default = "1000"
}

variable "pgid" {
  type    = string
  default = "1000"
}

variable "tz" {
  type    = string
  default = "Europe/Zurich"
}

variable "config_dir" {
  type    = string
  default = "/srv/jellyfin/config"
}

variable "cache_dir" {
  type    = string
  default = "/srv/jellyfin/cache"
}

variable "movies_dir" {
  type    = string
  default = "/mnt/mydrive/Media/Movies"
}

variable "tv_dir" {
  type    = string
  default = "/mnt/mydrive/Media/TV Shows"
}

variable "downloads_dir" {
  type    = string
  default = "/mnt/mydrive/Downloads"
}

variable "jellyfin_image" {
  type    = string
  default = "lscr.io/linuxserver/jellyfin:latest"
}

variable "bazarr_image" {
  type    = string
  default = "lscr.io/linuxserver/bazarr:latest"
}

variable "radarr_image" {
  type    = string
  default = "lscr.io/linuxserver/radarr:latest"
}

variable "sonarr_image" {
  type    = string
  default = "lscr.io/linuxserver/sonarr:latest"
}

variable "qbittorrent_image" {
  type    = string
  default = "lscr.io/linuxserver/qbittorrent:latest"
}

variable "bazarr_config_dir" {
  type    = string
  default = "/srv/bazarr/config"
}

variable "radarr_config_dir" {
  type    = string
  default = "/srv/radarr/config"
}

variable "sonarr_config_dir" {
  type    = string
  default = "/srv/sonarr/config"
}

variable "qbittorrent_config_dir" {
  type    = string
  default = "/srv/qbittorrent/config"
}

# If true, bootstrap will chown created dirs to PUID:PGID
variable "ensure_chown" {
  type    = bool
  default = true
}

# Jellyseerr
variable "jellyseerr_image" {
  description = "Container image for Jellyseerr"
  type        = string
  default     = "ghcr.io/fallenbagel/jellyseerr:latest"
}

variable "jellyseerr_port" {
  description = "Host port for Jellyseerr UI"
  type        = number
  default     = 5055
}


# ---------------- Dashboards ----------------
variable "homepage_image" {
  type    = string
  default = "ghcr.io/gethomepage/homepage:latest"
}

variable "homepage_port" {
  type    = number
  default = 3001
}

variable "homepage_config_dir" {
  type    = string
  default = "/srv/homepage/config"
}

variable "homarr_image" {
  type    = string
  default = "ghcr.io/ajnart/homarr:latest"
}

variable "homarr_port" {
  type    = number
  default = 7575
}

variable "homarr_data_dir" {
  type    = string
  default = "/srv/homarr/data"
}

# ---------------- Grafana ----------------
variable "grafana_image" {
  type    = string
  default = "grafana/grafana-oss:latest"
}

variable "grafana_port" {
  type    = number
  default = 3002
}

variable "grafana_data_dir" {
  type    = string
  default = "/srv/grafana/data"
}

variable "grafana_admin_user" {
  type    = string
  default = "admin"
}

variable "grafana_admin_password" {
  type    = string
  default = "admin"
}

# ---------------- Wazuh ----------------
variable "wazuh_manager_image" {
  type    = string
  default = "wazuh/wazuh-manager:latest"
}

variable "wazuh_indexer_image" {
  type    = string
  default = "wazuh/wazuh-indexer:latest"
}

variable "wazuh_dashboard_image" {
  type    = string
  default = "wazuh/wazuh-dashboard:latest"
}

variable "wazuh_dashboard_port" {
  type    = number
  default = 5601
}

variable "wazuh_manager_api_port" {
  type    = number
  default = 55000
}

variable "wazuh_indexer_port" {
  type    = number
  default = 9200
}

variable "wazuh_manager_data_dir" {
  type    = string
  default = "/srv/wazuh/manager"
}

variable "wazuh_indexer_data_dir" {
  type    = string
  default = "/srv/wazuh/indexer"
}
