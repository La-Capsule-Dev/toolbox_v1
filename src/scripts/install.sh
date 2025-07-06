#!/usr/bin/env bash

echo "Voulez-vous installer les dépendances nécessaires ? (Oui/Non)"
read reponse


#HACK: Refactoring la loop maybe
if [[ "$reponse" =~ ^([oO][uU][iI]|[oO])$ ]]
then
    sudo apt update &&
    PKGS_TO_INSTALL=("dmidecode" "dialog" "sed" "tr" "smartmontools" "skdump" "inxi" "acpi" "xrandr" "python3" "iconv" "enscript" "ps2pdf" "htop" "upower" "hardinfo" "arecord" "mplayer" "cheese" "arecord" "ffmpeg" "mplayer" "alsautils" "curl" "glxgears" "glmark2" "screentest" "libatasmart-bin" "smartctl" "nmon" "iptraf-ng" "s-tui" "stress-ng" "stress")

    for INSTALL_PKG in "${PKGS_TO_INSTALL[@]}"; do
        PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $INSTALL_PKG)
        echo "Recherche de $INSTALL_PKG: $PKG_OK"
        if ! dpkg-query -W --showformat='${Status}\n' $INSTALL_PKG | grep -q "Le paquet est bien installé"; then
            echo "Pas de $INSTALL_PKG sur le système. Configuration de $INSTALL_PKG."
            sudo apt-get --yes install $INSTALL_PKG
        fi
    done
else
    echo "L'installation des dépendances a été annulée."
fi

