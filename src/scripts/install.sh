#!/bin/bash

echo "Voulez-vous installer les dépendances nécessaires ? (Oui/Non)"
read reponse

if [[ "$reponse" =~ ^([oO][uU][iI]|[oO])$ ]]
then
sudo apt update &&
   REQUIRED_PKGS=("dmidecode" "dialog" "sed" "tr" "smartmontools" "skdump" "inxi" "acpi" "xrandr" "python3" "iconv" "enscript" "ps2pdf" "htop" "upower" "hardinfo" "arecord" "mplayer" "cheese" "arecord" "ffmpeg" "mplayer" "alsautils" "curl" "glxgears" "glmark2" "screentest" "libatasmart-bin" "smartctl" "nmon" "iptraf-ng" "s-tui" "stress-ng" "stress")

   for REQUIRED_PKG in "${REQUIRED_PKGS[@]}"; do
       PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG)
       echo "Recherche de $REQUIRED_PKG: $PKG_OK"
       if ! dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG | grep -q "Le paquet est bien installé"; then
           echo "Pas de $REQUIRED_PKG sur le système. Configuration de $REQUIRED_PKG."
           sudo apt-get --yes install $REQUIRED_PKG
       fi
   done
else
   echo "L'installation des dépendances a été annulée."
fi

