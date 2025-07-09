#!/usr/bin/env bash
set -euo pipefail

source "$MAINTENANCE_DIR/echo_status.sh"

fix_permissions() {
    echo_status "Obtention des droits sur les fichiers verrouillés"

    USER_ID="${SUDO_USER:-$USER}"

    if [[ -d /var/lib/dpkg ]]; then
        sudo chown "$USER_ID" -R /var/lib/dpkg/* \
            || echo_status_error "Échec chown /var/lib/dpkg (droits insuffisants ou fichiers inaccessibles)"
    else
        echo_status_error "Répertoire /var/lib/dpkg introuvable — système non Debian-based ou minimal"
    fi

    if [[ -d /var/cache/apt ]]; then
        sudo chown "$USER_ID" -R /var/cache/apt/* \
            || echo_status_error "Échec chown /var/cache/apt (droits insuffisants ou fichiers inaccessibles)"
    else
        echo_status_error "Répertoire /var/cache/apt introuvable — apt probablement non installé"
    fi

    echo_status_ok
}
