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
homarr_secret_encryption_key = "a1088a6b45ad30a77d9e18bf1169117e3acd299a03c2d424064d2df19f8cb03e"

grafana_port           = 3002
grafana_data_dir       = "/srv/grafana/data"
grafana_admin_user     = "admin"
grafana_admin_password = "ChangeMeNow123!"
