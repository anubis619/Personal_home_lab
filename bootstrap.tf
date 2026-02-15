############################################
# bootstrap.tf — ensure host paths exist
############################################

locals {
  required_dirs = [
    var.config_dir,
    var.cache_dir,

    # *arr stack configs
    var.bazarr_config_dir,
    var.radarr_config_dir,
    var.sonarr_config_dir,
    var.qbittorrent_config_dir,
    var.prowlarr_config_dir,
    var.uptimekuma_data_dir,
    var.portainer_data_dir,

    # Pi-hole + NPM
    var.pihole_data_dir,
    var.npm_data_dir,


    # Media mounts
    var.movies_dir,
    var.tv_dir,
    var.downloads_dir,

    # Dashboards
    var.homepage_config_dir,
    var.homarr_data_dir,
    var.grafana_data_dir
  ]
}

resource "null_resource" "ensure_paths" {
  triggers = {
    dirs  = join("|", local.required_dirs)
    chown = var.ensure_chown ? "1" : "0"
    puid  = var.puid
    pgid  = var.pgid
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
      set -euo pipefail

      echo "[bootstrap] Creating required directories..."
      for d in ${join(" ", formatlist("\"%s\"", local.required_dirs))}; do
        sudo mkdir -p "$d"

        # Optional ownership fixing.
        # Avoid doing recursive chown on big media mounts.
        if [ "${var.ensure_chown}" = "true" ]; then
          case "$d" in
            "${var.movies_dir}"|"${var.tv_dir}"|"${var.downloads_dir}")
              echo "[bootstrap] Skipping recursive chown for media mount: $d"
              ;;
            *)
              sudo chown -R ${var.puid}:${var.pgid} "$d"
              ;;
          esac
        fi
      done

      echo "[bootstrap] Done."
    EOT
  }
}