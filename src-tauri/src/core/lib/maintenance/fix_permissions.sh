#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/ui/echo_status.sh"

fix_and_warn() {
    local dir="$1"
    local user_id="$2"
    if [[ -d "$dir" ]]; then
        sudo chown "$user_id" -R "$dir"/* || echo_status_warn "Échec chown sur $dir"
    else
        echo_status_warn "Pas de $dir"
    fi
}

fix_permissions() {
    local os="$1"
    local user_id="${SUDO_USER:-$USER}"

    case "$os" in
        debian)
            fix_and_warn /var/lib/dpkg "$user_id"
            fix_and_warn /var/cache/apt "$user_id"
            ;;
        arch)
            fix_and_warn /var/lib/pacman "$user_id"
            fix_and_warn /var/cache/pacman/pkg "$user_id"
            ;;
        fedora)
            fix_and_warn /var/cache/dnf "$user_id"
            ;;
        alpine)
            fix_and_warn /etc/apk "$user_id"
            fix_and_warn /var/cache/apk "$user_id"
            ;;
        gentoo)
            fix_and_warn /var/db/pkg "$user_id"
            ;;
        void)
            fix_and_warn /var/db/xbps "$user_id"
            fix_and_warn /var/cache/xbps "$user_id"
            ;;
        opensuse)
            fix_and_warn /var/cache/zypp "$user_id"
            ;;
        *)
            echo_status_warn "fix_permissions : $os non supporté ou mapping manquant"
            ;;
    esac

    echo_status_ok "Obtention des droits réussi"
}
