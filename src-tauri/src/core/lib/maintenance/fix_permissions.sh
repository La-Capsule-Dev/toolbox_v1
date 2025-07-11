#!/usr/bin/env bash
set -euo pipefail

source "$DIR_ROOT/lib/utils/echo_status.sh"

fix_permissions() {
    local os="$1"
    local user_id="${SUDO_USER:-$USER}"

    case "$os" in
        debian)
            [[ -d /var/lib/dpkg ]] && sudo chown "$user_id" -R /var/lib/dpkg/* || echo_status_warn "Pas de /var/lib/dpkg"
            [[ -d /var/cache/apt ]] && sudo chown "$user_id" -R /var/cache/apt/* || echo_status_warn "Pas de /var/cache/apt"
            ;;
        arch)
            [[ -d /var/lib/pacman ]] && sudo chown "$user_id" -R /var/lib/pacman/* || echo_status_warn "Pas de /var/lib/pacman"
            [[ -d /var/cache/pacman/pkg ]] && sudo chown "$user_id" -R /var/cache/pacman/pkg/* || echo_status_warn "Pas de /var/cache/pacman/pkg"
            ;;
        fedora)
            [[ -d /var/cache/dnf ]] && sudo chown "$user_id" -R /var/cache/dnf/* || echo_status_warn "Pas de /var/cache/dnf"
            ;;
        alpine)
            [[ -d /etc/apk ]] && sudo chown "$user_id" -R /etc/apk/* || echo_status_warn "Pas de /etc/apk"
            [[ -d /var/cache/apk ]] && sudo chown "$user_id" -R /var/cache/apk/* || echo_status_warn "Pas de /var/cache/apk"
            ;;
        gentoo)
            [[ -d /var/db/pkg ]] && sudo chown "$user_id" -R /var/db/pkg/* || echo_status_warn "Pas de /var/db/pkg"
            ;;
        void)
            [[ -d /var/db/xbps ]] && sudo chown "$user_id" -R /var/db/xbps/* || echo_status_warn "Pas de /var/db/xbps"
            [[ -d /var/cache/xbps ]] && sudo chown "$user_id" -R /var/cache/xbps/* || echo_status_warn "Pas de /var/cache/xbps"
            ;;
        opensuse)
            [[ -d /var/cache/zypp ]] && sudo chown "$user_id" -R /var/cache/zypp/* || echo_status_warn "Pas de /var/cache/zypp"
            ;;
        *)
            echo_status_warn "fix_permissions : $OS non supporté ou mapping manquant"
            ;;
    esac

    echo_status_ok "Obtention des droits réussi"
}
