#!/usr/bin/env bash
set -euo pipefail

source "$DIR_ROOT/lib/utils/echo_status.sh"

install_pkgs(){
    local options="${@: -1}"
    local pkgs=("${@:1:$(($#-1))}")

    for REQUIRED_PKG in "${pkgs[@]}"; do
        PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG)
        echo_status "Vérification pour $REQUIRED_PKG: $PKG_OK"

        if ! dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG 2>/dev/null | grep -q "Le paquet est bien installé"; then
            echo_status "Pas de $REQUIRED_PKG. Installation de $REQUIRED_PKG."
            sudo apt-get --yes install $REQUIRED_PKG || echo_status_error "Impossible de lancer l'installation apt-get install, voir loops_pkgs.sh"
            if [[ "$options" == "gnome-terminal" ]]; then
                gnome-terminal -- '/usr/share/LACAPSULE/MULTITOOL/bootstrap.sh'
            else
                echo_status_error "Le package gnome-terminal est introuvable"
            fi
        fi
    done

    echo_status_ok "Installation réussie"
}

remove_pkgs(){
    local pkgs=("$@")

    for REQUIRED_PKG in "${pkgs[@]}"; do
        PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG)
        echo_status "Vérification pour $REQUIRED_PKG: $PKG_OK"

        if ! dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG 2>/dev/null | grep -q "Le paquet est bien installé"; then
            echo_status "$REQUIRED_PKG est installé, désintallation de $REQUIRED_PKG."
            sudo apt-get --yes remove $REQUIRED_PKG
        else
            echo_status_error "$REQUIRED_PKG non installé."
        fi

    done

    echo_status_ok "Désinstallation réussie"
}

#TODO: Later
# missing_pkgs(){
#
# }

