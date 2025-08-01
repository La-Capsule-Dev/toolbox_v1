#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/ui/echo_status.sh"
source "$LIB_DIR/utils/detect_os_id.sh"

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
    local trash_path="$HOME/.local/share/Trash"
    local os_id
    os_id="$(detect_os_id)"

    echo_status "Nettoyage des caches et fichiers temporaires utilisateur"

    # Vidage de $HOME/tmp
    safe_clean_dir \
        "$HOME/tmp" \
        "Vidage $HOME/tmp réussi" \
        "Échec suppression de $HOME/tmp" \
        "Répertoire $HOME/tmp introuvable"

    # Purge du cache utilisateur (~/.cache)
    safe_clean_dir \
        "$HOME/.cache" \
        "Purge du cache utilisateur réussie" \
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

    echo_status "Nettoyage des caches système/paquets ($os_id)"

    case "$os_id" in
        fedora)
            if sudo dnf clean all; then
                echo_status_ok "Cache DNF vidé"
            else
                echo_status_error "Échec purge cache DNF"
            fi
            ;;
        debian|ubuntu|linuxmint)
            if sudo apt-get autoclean -y && sudo apt-get clean; then
                echo_status_ok "Cache APT vidé"
            else
                echo_status_error "Échec purge cache APT"
            fi
            ;;
        arch)
            if sudo pacman -Scc --noconfirm; then
                echo_status_ok "Cache Pacman vidé"
            else
                echo_status_error "Échec purge cache Pacman"
            fi
            ;;
        alpine)
            if sudo apk cache clean; then
                echo_status_ok "Cache APK vidé"
            else
                echo_status_error "Échec purge cache APK"
            fi
            ;;
        void)
            if sudo xbps-remove -Oo; then
                echo_status_ok "Cache XBPS vidé"
            else
                echo_status_error "Échec purge cache XBPS"
            fi
            ;;
        opensuse)
            if sudo zypper clean --all; then
                echo_status_ok "Cache Zypper vidé"
            else
                echo_status_error "Échec purge cache Zypper"
            fi
            ;;
        gentoo)
            echo_status_warn "Nettoyage cache Gentoo non supporté en auto (voir eclean, emaint)."
            ;;
        *)
            echo_status_warn "OS non reconnu pour nettoyage de cache système."
            ;;
    esac
}
