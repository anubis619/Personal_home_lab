# Preset qBittorrent config: default paths, Automatic mode, categories
resource "null_resource" "qbittorrent_preset" {
  depends_on = [null_resource.ensure_paths]

  triggers = {
    cfgdir = var.qbittorrent_config_dir
    dl     = var.downloads_dir
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
      set -euo pipefail

      CONF_DIR="${var.qbittorrent_config_dir}/qBittorrent"
      CONF_FILE="${var.qbittorrent_config_dir}/qBittorrent/qBittorrent.conf"

      # Ensure directories used by categories and temp path exist
      sudo mkdir -p "$CONF_DIR"
      sudo mkdir -p "${var.downloads_dir}/tv" "${var.downloads_dir}/movies" "${var.downloads_dir}/incomplete"

      # Create file if missing; ensure [Preferences] section exists
      if [ ! -f "$CONF_FILE" ]; then
        echo "[Preferences]" | sudo tee "$CONF_FILE" >/dev/null
      elif ! grep -q '^\\[Preferences\\]' "$CONF_FILE"; then
        printf "\\n[Preferences]\\n" | sudo tee -a "$CONF_FILE" >/dev/null
      fi

      # Helper to set/replace a pref key (note the $$ to escape Terraform)
      set_pref () {
        local key="$1" ; local val="$2"
        if grep -q "^$${key}=" "$CONF_FILE"; then
          sudo sed -i -E "s|^$${key}=.*|$${key}=$${val}|" "$CONF_FILE"
        else
          sudo awk -v k="$${key}" -v v="$${val}" '
            BEGIN{added=0}
            /^\\[Preferences\\]/{print; print k"="v; added=1; next}
            {print}
            END{if(!added) print "[Preferences]\n"k"="v}
          ' "$CONF_FILE" | sudo tee "$CONF_FILE.tmp" >/dev/null
          sudo mv "$CONF_FILE.tmp" "$CONF_FILE"
        fi
      }

      # Core download prefs
      set_pref "Downloads\\\\SavePath" "/downloads"
      set_pref "Downloads\\\\TempPathEnabled" "true"
      set_pref "Downloads\\\\TempPath" "/downloads/incomplete"

      # Automatic torrent management: 1 = Automatic, 0 = Manual
      set_pref "TorrentManagementMode" "1"

      # Categories section
      if ! grep -q '^\\[Categories\\]' "$CONF_FILE"; then
        printf "\\n[Categories]\\n" | sudo tee -a "$CONF_FILE" >/dev/null
      fi

      # Define categories tv/movies and enable their save paths
      sudo sed -i -E '/^tv\\\SavePath=/d; /^tv\\\SavePathEnabled=/d; /^movies\\\SavePath=/d; /^movies\\\SavePathEnabled=/d' "$CONF_FILE"
      printf "tv\\\SavePath=/downloads/tv\\n"        | sudo tee -a "$CONF_FILE" >/dev/null
      printf "tv\\\SavePathEnabled=true\\n"          | sudo tee -a "$CONF_FILE" >/dev/null
      printf "movies\\\SavePath=/downloads/movies\\n"| sudo tee -a "$CONF_FILE" >/dev/null
      printf "movies\\\SavePathEnabled=true\\n"      | sudo tee -a "$CONF_FILE" >/dev/null

      # Ownership for container user
      sudo chown -R ${var.puid}:${var.pgid} "${var.qbittorrent_config_dir}" "${var.downloads_dir}"
    EOT
  }
}
