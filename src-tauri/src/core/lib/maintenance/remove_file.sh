#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/pkgmgr/wrapper.sh"
source "$LIB_DIR/ui/echo_status.sh"

safe_clean_dir() {
    local dir="$1" ok_msg="$2" err_msg="$3" notfound_msg="$4"
    if [[ -d "$dir" ]]; then
        if sudo find "$dir" -mindepth 1 -delete; then
            echo_status_ok "$ok_msg"
        else
            echo_status_error "$err_msg"
        fi
    else
        echo_status_warn "$notfound_msg"
    fi
}


remove_files() {
    local os_type
    os_type="$(detect_os)"   # Ex : renvoie "debian", "arch", etc.
    local trash_path="$HOME/.local/share/Trash"

    echo_status "Nettoyage des caches et fichiers temporaires"

    # Nettoyage des paquets obsolètes (OS-agnostique)
    autoclean_pkgs_native "$os_type"

    # Suppression des dépendances inutiles (OS-agnostique)
    autoremove_pkgs_native "$os_type"

    # Vidage de $HOME/tmp
    safe_clean_dir \
        "$HOME/tmp" \
        "Vidage $HOME/tmp" \
        "Échec suppression de $HOME/tmp" \
        "Répertoire $HOME/tmp introuvable"

    # Purge du cache utilisateur (~/.cache)
    safe_clean_dir \
        "$HOME/.cache" \
        "Purge du cache utilisateur" \
        "Échec purge de $HOME/.cache" \
        "Répertoire $HOME/.cache introuvable"

    # Vidage de la corbeille (fichiers)
    safe_clean_dir \
        "$trash_path/files" \
        "Corbeille (fichiers) vidée" \
        "Échec vidage $trash_path/files" \
        "Dossier $trash_path/files introuvable"

    # Vidage de la corbeille (info)
    safe_clean_dir \
        "$trash_path/info" \
        "Corbeille (info) vidée" \
        "Échec vidage $trash_path/info" \
        "Dossier $trash_path/info introuvable"
}
