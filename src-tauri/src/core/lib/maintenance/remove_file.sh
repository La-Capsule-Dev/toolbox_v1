#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DIR_ROOT="${BIN_DIR%%/core*}/core"
source "$DIR_ROOT/lib/pkgmgr/wrapper.sh"
source "$DIR_ROOT/lib/ui/echo_status.sh"

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
    if [[ -d "$HOME/tmp" ]]; then
        sudo find "$HOME/tmp" -mindepth 1 -delete \
            && echo_status_ok "Vidage $HOME/tmp" \
            || echo_status_error "Échec suppression de $HOME/tmp"
    else
        echo_status_warn "Répertoire $HOME/tmp introuvable"
    fi

    # Purge du cache utilisateur (~/.cache)
    if [[ -d "$HOME/.cache" ]]; then
        sudo find "$HOME/.cache" -mindepth 1 -delete \
            && echo_status_ok "Purge du cache utilisateur" \
            || echo_status_error "Échec purge de $HOME/.cache"
    else
        echo_status_warn "Répertoire $HOME/.cache introuvable"
    fi

    # Vidage de la corbeille (fichiers)
    if [[ -d "$trash_path/files" ]]; then
        sudo find "$trash_path/files" -mindepth 1 -delete \
            && echo_status_ok "Corbeille (fichiers) vidée" \
            || echo_status_error "Échec vidage $trash_path/files"
    else
        echo_status_warn "Dossier $trash_path/files introuvable"
    fi

    # Vidage de la corbeille (info)
    if [[ -d "$trash_path/info" ]]; then
        sudo find "$trash_path/info" -mindepth 1 -delete \
            && echo_status_ok "Corbeille (info) vidée" \
            || echo_status_error "Échec vidage $trash_path/info"
    else
        echo_status_warn "Dossier $trash_path/info introuvable"
    fi
}
