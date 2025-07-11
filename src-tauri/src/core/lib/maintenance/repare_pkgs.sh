#!/usr/bin/env bash
set -euo pipefail

source "$DIR_ROOT/lib/utils/echo_status.sh"
source "$DIR_ROOT/lib/utils/detect_os.sh"
source "$DIR_ROOT/lib/pkgmgr/wrapper.sh"

repare_pkgs_native() {
    local os="$1"

    # 1. Update
    echo_status "Mise à jour des paquets"
    if update_pkgs_native "$os"; then
        echo_status_ok "Mise à jour réussie"
    else
        echo_status_error "Échec de la mise à jour"
    fi

    # 2. Fix broken (Debian/Ubuntu only)
    if [[ "$os" == "debian" ]]; then
        echo_status "Réparation des paquets cassés"
        if sudo apt --fix-broken install -y; then
            echo_status_ok "Réparation des paquets cassés réussie"
        else
            echo_status_error "Échec fix-broken"
        fi
    fi

    # 3. Clean/autoclean
    echo_status "Nettoyage des paquets obsolètes"
    if autoclean_pkgs_native "$os"; then
        echo_status_ok "Nettoyage réussi"
    else
        echo_status_error "Échec nettoyage"
    fi

    # 4. Autoremove
    echo_status "Suppression des dépendances inutiles"
    if autoremove_pkgs_native "$os"; then
        echo_status_ok "Suppression des dépendances inutiles réussie"
    else
        echo_status_error "Échec suppression dépendances"
    fi
}
