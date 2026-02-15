puid = "1000"
pgid = "1000"
tz   = "Europe/Zurich"

config_dir = "/srv/jellyfin/config"
cache_dir  = "/srv/jellyfin/cache"
movies_dir = "/mnt/mydrive/Media/Movies"
tv_dir     = "/mnt/mydrive/Media/TV Shows"

bazarr_config_dir      = "/srv/bazarr/config"
radarr_config_dir      = "/srv/radarr/config"
sonarr_config_dir      = "/srv/sonarr/config"
qbittorrent_config_dir = "/srv/qbittorrent/config"

downloads_dir = "/mnt/mydrive/Downloads"

ensure_chown = true

# Dashboards
homepage_port       = 3000
homepage_config_dir = "/srv/homepage/config"

homarr_port     = 7575
homarr_data_dir = "/srv/homarr/data"

# DO NOT change after first run
homarr_secret_encryption_key = "REDACTED"

grafana_port           = 3002
grafana_data_dir       = "/srv/grafana/data"
grafana_admin_user     = "admin"
grafana_admin_password = "ChangeMeNow123!"

prowlarr_config_dir = "/srv/prowlarr/config"
prowlarr_port       = 9696

uptimekuma_data_dir = "/srv/uptimekuma/data"
uptimekuma_port     = 3001

portainer_data_dir = "/srv/portainer/data"
portainer_port     = 9443

portainer_enable_edge_tunnel = false
portainer_edge_tunnel_port   = 8000
PIHOLE_WEBPASSWORD           = "ChangeMeNow123!"
