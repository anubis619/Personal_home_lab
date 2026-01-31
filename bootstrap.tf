locals {
  # "Normal" dirs that we can safely chown to PUID:PGID
  required_dirs = [
    var.config_dir,
    var.cache_dir,

    # Wazuh: dashboard config + cert tooling dirs (NOT certs)
    var.wazuh_dashboard_config_dir,
    var.wazuh_host_config_dir,

    # *arr stack configs
    var.bazarr_config_dir,
    var.radarr_config_dir,
    var.sonarr_config_dir,
    var.qbittorrent_config_dir,

    # Media mounts
    var.movies_dir,
    var.tv_dir,
    var.downloads_dir,

    # Dashboards
    var.homepage_config_dir,
    var.homarr_data_dir,
    var.grafana_data_dir,

    # Wazuh data
    var.wazuh_manager_data_dir,
    var.wazuh_indexer_data_dir
  ]

  # Wazuh certs dir handled separately (create + permissions only)
  wazuh_certs_dir = var.wazuh_certs_dir
}

resource "null_resource" "ensure_paths" {
  triggers = {
    dirs       = join("|", local.required_dirs)
    certs_dir  = local.wazuh_certs_dir
    chown      = var.ensure_chown ? "1" : "0"
    puid       = var.puid
    pgid       = var.pgid
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command = <<-EOT
      set -euo pipefail

      echo "[bootstrap] Creating required directories..."
      for d in ${join(" ", formatlist("\"%s\"", local.required_dirs))}; do
        sudo mkdir -p "$d"

        # Only chown normal dirs
        if [ "${var.ensure_chown}" = "true" ]; then
          sudo chown -R ${var.puid}:${var.pgid} "$d"
        fi
      done

      # Handle Wazuh certs dir separately:
      # - create it
      # - DO NOT recursively chown it here (cert generator + normalize step will handle files)
      # - keep perms readable so containers can read mounted certs
      echo "[bootstrap] Ensuring Wazuh certs dir exists (no recursive chown): ${local.wazuh_certs_dir}"
      sudo mkdir -p "${local.wazuh_certs_dir}"

      # directory needs to be traversable/readable
      sudo chmod 755 "${local.wazuh_certs_dir}" || true

      # If any certs already exist from a previous run, make sure they are readable
      # (wazuh-indexer must read root-ca.pem etc.)
      sudo find "${local.wazuh_certs_dir}" -maxdepth 1 -type f \\( -name "*.pem" -o -name "*.crt" -o -name "*.key" \\) -exec chmod 644 {} \\; 2>/dev/null || true

      echo "[bootstrap] Done."
    EOT
  }
}
