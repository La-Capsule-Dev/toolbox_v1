#!/usr/bin/env bash
set -euo pipefail

source "$CORE_DIR/etc/config/path.env"
source "$ETC_DIR/config/pkgs-list.sh"
source "$LIB_DIR/pkgmgr/wrapper.sh"
source "$LIB_DIR/utils/init.sh"
source "$LIB_DIR/maintenance/init.sh"

clean_up() {
    local os_type
    os_type="$(detect_os)"
    echo_status "Début du nettoyage intégral..."
    echo_status "Obtention des droits sur les fichiers verrouillés"
    echo_status "Veuillez entrer votre mot de passe administrateur"

    # Fixing permissions
    fix_permissions "$os_type" && repare_pkgs_native "$os_type"
    drop_memory_cache

    # Removing pkgs
    echo_status "Suppression de paquets spécifiques via remove_pkgs"
    autoremove_pkgs_native "$os_type" "${PKGS_[@]}"

    # Remove files
    echo_status "Nettoyage des fichiers inutiles"
    remove_files && echo_status_ok "Nettoyage effectué avec succès"
}

drop_memory_cache(){
    echo_status "Vidage du cache mémoire (drop_caches)"
    sync
    sudo sysctl vm.drop_caches=3 || echo_status_error "Échec drop_caches"
    echo_status_ok "Cache mémoire vidé"
    echo_status "État de la mémoire :"
    swapon -s || echo_status_error "Échec swapon"
    free -m  || echo_status_error "Échec free"
}

clean_up
