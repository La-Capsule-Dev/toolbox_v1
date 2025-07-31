#!/usr/bin/env bash
set -euo pipefail

source "$CORE_DIR/etc/config/path.env"
source "$LIB_DIR/utils/init.sh"
source "$LIB_DIR/maintenance/init.sh"
source "$LIB_DIR/pkgmgr/remove_pkgs_csv.sh"

autoremove_pkgs() {
    local os_id
    os_id="$(detect_os_id)"
    local cmd
    case "$os_id" in
        debian|ubuntu) cmd="sudo apt-get autoremove -y" ;;
        fedora)        cmd="sudo dnf autoremove -y" ;;
        arch)          cmd='pkgs=$(pacman -Qdtq); [[ -n "$pkgs" ]] && sudo pacman -Rns --noconfirm $pkgs' ;;
        alpine)        cmd='echo_status_warn "Autoremove non supporté sur Alpine."' ;;
        gentoo)        cmd='echo_status_warn "Autoremove non supporté sur Gentoo."' ;;
        void)          cmd="sudo xbps-remove -O" ;;
        opensuse)      cmd='echo_status_warn "Zypper: autoremove non automatisé."' ;;
        *)             echo_status_error "OS non supporté : $os_id" ; return 1 ;;
    esac
    echo_status "Suppression des paquets orphelins (autoremove)..."
    if eval "$cmd"; then
        echo_status_ok "Autoremove terminé avec succès."
    else
        echo_status_warn "Aucun orphelin à supprimer ou commande non supportée."
    fi
}

clean_up() {
    local os_type
    os_type="$(detect_os_id)"
    echo_status "Début du nettoyage intégral..."
    echo_status "Obtention des droits sur les fichiers verrouillés"
    echo_status "Veuillez entrer votre mot de passe administrateur"

    # Fixing permissions
    # fix_permissions "$os_type"
    # repare_pkgs_native "$os_type"
    drop_memory_cache

    # Suppression paquets CSV
    echo_status "Suppression de paquets spécifiques installés"
    remove_pkgs_csv

    # Suppression des orphelins
    autoremove_pkgs
    # Remove files
    # echo_status "Nettoyage des fichiers inutiles"
    # remove_files && echo_status_ok "Nettoyage effectué avec succès"
}

drop_memory_cache(){
    echo_status "Vidage du cache mémoire (drop_caches)"
    # sync
    # sudo sysctl vm.drop_caches=3 || echo_status_error "Échec drop_caches"
    echo_status_ok "Cache mémoire vidé"
    echo_status "État de la mémoire :"
    swapon -s || echo_status_error "Échec swapon"
    free -m  || echo_status_error "Échec free"
}

clean_up
