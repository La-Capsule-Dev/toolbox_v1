#!/usr/bin/env bash
set -euo pipefail


install_pkgs(){
    local options="${@: -1}"
    local pkgs=("${@:1:$(($#-1))}")

    for REQUIRED_PKG in "${pkgs[@]}"; do
        PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG)
        echo "Vérification pour $REQUIRED_PKG: $PKG_OK"

        if ! dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG 2>/dev/null | grep -q "Le paquet est bien installé"; then
            echo "Pas de $REQUIRED_PKG. Installation de $REQUIRED_PKG."
            sudo apt-get --yes install $REQUIRED_PKG
            if [[ "$options" == "gnome-terminal" ]]; then
                gnome-terminal -- '/usr/share/LACAPSULE/MULTITOOL/bootstrap.sh'
            fi
        fi
    done
}

remove_pkgs(){
    local pkgs=("$@")

    for REQUIRED_PKG in "${pkgs[@]}"; do
        PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG)
        echo "Vérification pour $REQUIRED_PKG: $PKG_OK"

        if ! dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG 2>/dev/null | grep -q "Le paquet est bien installé"; then
            echo "$REQUIRED_PKG est installé, désintallation de $REQUIRED_PKG."
            sudo apt-get --yes remove $REQUIRED_PKG
        else
            echo "$REQUIRED_PKG non installé."
        fi
    done
}

#TODO: Later
# missing_pkgs(){
#
# }

