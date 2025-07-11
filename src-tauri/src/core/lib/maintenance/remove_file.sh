#!/usr/bin/env bash
set -euo pipefail

source "$DIR_ROOT/lib/utils/echo_status.sh"

remove_files(){
    TRASH_PATH="$HOME/.local/share/Trash"

    echo_status "Nettoyage du système de fichiers"

    echo_status "Nettoyage du cache apt (autoclean)"
    sudo apt autoclean -y && echo_status_ok "Nettoyage du cache"|| echo_status_error "Échec de apt autoclean"

    echo_status "Suppression automatique des paquets (autoremove)"
    sudo apt autoremove -y && echo_status_ok "Suprression des paquets"|| echo_status_error "Échec de apt autoremove"

    echo_status "Vidage du répertoire /tmp"
    if [[ -d "$HOME/tmp" ]]; then
        sudo find "$HOME/tmp" -mindepth 1 -delete && echo_status_ok "Vidage /tmp"|| echo_status_error "Échec suppression de $HOME/tmp"
    else
        echo_status_error "Répertoire $HOME/tmp introuvable"
    fi

    echo_status "Purge du cache utilisateur"
    if [[ -d "$HOME/.cache" ]]; then
        sudo find "$HOME/.cache" -mindepth 1 -delete && echo_status_ok "Purge du cache utilisateur"|| echo_status_error "Échec purge de $HOME/.cache"
    else
        echo_status_error "Répertoire $HOME/.cache introuvable"
    fi

    echo_status "Vidage des fichiers dans la corbeille"
    if [[ -d "$TRASH_PATH/files" ]]; then
        sudo find "$TRASH_PATH/files" -mindepth 1 -delete && echo_status_ok "Corbeille vidé"|| echo_status_error "Échec vidage $TRASH_PATH/files"
    else
        echo_status_error "Dossier $TRASH_PATH/files introuvable"
    fi

    echo_status "Vidage des infos de la corbeille"
    if [[ -d "$TRASH_PATH/info" ]]; then
        sudo find "$TRASH_PATH/info" -mindepth 1 -delete && echo_status_ok "Corbeille info vidé"|| echo_status_error "Échec vidage $TRASH_PATH/info"
    else
        echo_status_error "Dossier $TRASH_PATH/info introuvable"
    fi
}
