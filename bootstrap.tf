locals {
  required_dirs = [
    var.config_dir,
    var.cache_dir,
    var.bazarr_config_dir,
    var.radarr_config_dir,
    var.sonarr_config_dir,
    var.qbittorrent_config_dir,
    var.movies_dir,
    var.tv_dir,
    var.downloads_dir
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
      for d in ${join(" ", formatlist("\"%s\"", local.required_dirs))}; do
        sudo mkdir -p "$d"
        if [ "${var.ensure_chown}" = "true" ]; then
          sudo chown -R ${var.puid}:${var.pgid} "$d"
        fi
      done
    EOT
  }
}
