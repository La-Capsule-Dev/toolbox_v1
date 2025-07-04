#!/usr/bin/env bash

set -euo pipefail

gui_install(){
HARDINFO_PKGS=("hardinfo")
#TODO: To refactor in loop-pkgs
for HARDINFO in "${HARDINFO_PKGS[@]}"; do
 PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $HARDINFO)
 echo "Checking for $HARDINFO: $PKG_OK"
 if ! dpkg-query -W --showformat='${Status}\n' $HARDINFO | grep -q "Le paquet est bien installé"; then
   echo "No $HARDINFO. Setting up $HARDINFO."
   sudo apt-get --yes install $HARDINFO
 fi
done
printf '\e[8;1;1t'
hardinfo
}
gui_install
