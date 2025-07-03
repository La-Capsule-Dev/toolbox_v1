#!/usr/bin/env bash
set -euo pipefail
REQUIRED_PKGS=("dmidecode" "curl" "sed" "tr" "smartmontools" "skdump" "inxi" "acpi" "xrandr" "python3" "iconv" "enscrypt" "ps2pdf" "htop" "upower" "hardinfo" "arecord" "ffplay" "glxgears" "glmark2" "screentest" "libatasmart-bin" "smartctl" "nmon" "iptraf-ng" "s-tui" "stress")


install_or_remove_pkgs(){
  local actions="$1"

  for REQUIRED_PKG in "${REQUIRED_PKGS[@]}"; do
   PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG)
   echo "Vérification pour $REQUIRED_PKG: $PKG_OK"

   if ! dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG | grep -q "Le paquet est bien installé"; then
      if [[ "$actions" == "install" ]]; then
       echo "Pas de $REQUIRED_PKG. Installation de $REQUIRED_PKG."
       sudo apt-get --yes install $REQUIRED_PKG
     fi

      if [[ "$actions" == "remove" ]]; then
       echo "$REQUIRED_PKG est installé, désintallation de $REQUIRED_PKG."
       sudo apt-get --yes remove $REQUIRED_PKG
     fi
   fi 
  done
}


