#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DIR_ROOT="${BIN_DIR%%/core*}/core"

source "$DIR_ROOT/etc/config/pkgs.sh"
source "$DIR_ROOT/lib/maintenance/loop-pkgs.sh"
source "$DIR_ROOT/lib/utils/init.sh"

launch_maj(){

    echo "Début du script de maintenance..."

    # Fix permissions
    fix_permissions

    # Repare Packages
    repare_pkgs

    # Installation de nouveaux paquets
    echo_status "Téléchargement et installation des nouveaux paquets"
    install_pkgs "${PKGS[@]}" && echo_status_ok || echo_status_error "Échec installation paquets"

    # Upgrade system
    echo_status "Mise à niveau du système"
    sudo apt upgrade -y && sudo apt full-upgrade -y && echo_status_ok || echo_status_error "Échec upgrade"

    # Cancel purge
    cancel_purge

    # Remove files
    remove_files

    echo ""
    echo_status "La maintenance a été effectuée avec succès"
    echo_status "👍👍👍"
    echo ""
}

cancel_purge(){

    echo_status "Appuyer sur les touches ctrl+c pour annuler la purge"
    sleep 10
    echo -e "\033[1;31m!!! ATTENTION !!!\033[0m"
    echo_status "LA PURGE VA COMMENCER !"

    for i in 5 4 3 2 1; do
        echo "$i"
        sleep 1
    done

}
launch_maj
