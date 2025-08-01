#!/usr/bin/env bash
set -euo pipefail

source "$CORE_DIR/lib/ui/echo_status.sh"
source "$LIB_DIR/maintenance/init.sh"

update_pkgs() {
    local os_id="$1"
    local stamp="${HOME}/.cache/last_update_${os_id}.stamp"
    local min_delay=300  # 5 min
    mkdir -p "${HOME}/.cache"
    if [[ -f "$stamp" ]] && [[ $(( $(date +%s) - $(stat -c %Y "$stamp") )) -lt $min_delay ]]; then
        echo_status_warn "Update déjà fait il y a moins de 5 minutes. Skip."
        return 0   # SUCCÈS, mais “pas d’action”
    fi
    full_pkg_maintenance "$os_id"
    touch "$stamp"
    return 0
}
