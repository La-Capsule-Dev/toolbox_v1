#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DIR_ROOT="${BIN_DIR%%/core*}/core"

source "$DIR_ROOT/etc/config/pkgs.sh"
source "$DIR_ROOT/lib/maintenance/loop-pkgs.sh"
source "$DIR_ROOT/lib/utils/init.sh"

launch_maj(){

    echo_status "Début du script de maintenance..."

    # Fix permissions and Packages
    fix_permissions && repare_pkgs

    # Installation de nouveaux paquets
    echo_status "Téléchargement et installation des nouveaux paquets"
    install_pkgs "${PKGS[@]}" && echo_status_ok "Téléchargement et installation réussi" || echo_status_error "Échec installation paquets"

    # Upgrade system
    echo_status "Mise à niveau du système"
    sudo apt upgrade -y && sudo apt full-upgrade -y && echo_status_ok "Mise à jour" || echo_status_error "Échec upgrade"

    # Purge
    cancel_purge && remove_files

    echo_status_ok "La maintenance a été effectuée avec succès"
}

cancel_purge(){
    echo_status_warn "!!! ATTENTION !!!" && echo_status_warn "LA PURGE VA COMMENCER !"
    echo_status_warn "Appuyer sur les touches ctrl+c pour annuler la purge"
    for i in 6 5 4 3 2 1; do
        echo "$i"
        sleep 1
    done
}

launch_maj
