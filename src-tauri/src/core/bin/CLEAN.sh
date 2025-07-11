#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DIR_ROOT="${BIN_DIR%%/core*}/core"

source "$DIR_ROOT/etc/config/pkgs-list.sh"
source "$DIR_ROOT/lib/pkgmgr/wrapper.sh"
source "$DIR_ROOT/lib/utils/init.sh"

clean_up() {
    local os_type
    os_type="$(detect_os)"
    echo_status "Début du nettoyage intégral..."
    echo_status "Obtention des droits sur les fichiers verrouillés"
    echo_status "Veuillez entrer votre mot de passe administrateur"

    # Fixing permissions
    fix_permissions $os_type && repare_pkgs_native $os_type && drop_memory_cache

    # Removing pkgs
    echo_status "Suppression de paquets spécifiques via remove_pkgs"
    remove_pkgs_native "$os_type" "${PKGS[@]}"

    # Delete package boot-repair
    echo_status "Suppression du paquet boot-repair"
    remove_one_pkg_native $os_type "boot-repair" && echo_status_ok "Boot-repair supprimé"|| echo_status_error "Échec suppression boot-repair"

    # Delete eggs
    delete_eggs

    # Remove files
    echo_status "Nettoyage des fichiers inutiles"
    remove_files && echo_status_ok "Nettoyage effectué avec succès"
}

delete_eggs(){
    # FIX: Voir la plus tard
    # ❌ Correction : dpkg -r ne prend pas un .deb, mais un nom de paquet
    # Si tu veux supprimer le paquet installé par ce .deb, tu dois en extraire le nom
    # Exemple : sudo dpkg -r eggs
    # Tu peux automatiser cela avec dpkg -I :
    #   pkg_name=$(dpkg-deb -f MULTITOOL/eggs_9.6.8_amd64.deb Package)

    if [[ -f "MULTITOOL/eggs_9.6.8_amd64.deb" ]]; then
        pkg_name=$(dpkg-deb -f MULTITOOL/eggs_9.6.8_amd64.deb Package)
        echo_status "Suppression du paquet installé depuis eggs_9.6.8"
        sudo dpkg -r "$pkg_name" && echo_status_ok || echo_status_error "Échec suppression $pkg_name"
    else
        echo_status_error "Fichier MULTITOOL/eggs_9.6.8_amd64.deb introuvable"
    fi
}

drop_memory_cache(){
    echo_status "Vidage du cache mémoire (drop_caches)"
    sync && sudo sysctl vm.drop_caches=3 && echo_status_ok "Cache mémoire vidé"|| echo_status_error "Échec drop_caches"
    echo_status "État de la mémoire :"
    swapon -s || echo_status_error "Échec swapon"
    free -m  || echo_status_error "Échec free"
}

clean_up
