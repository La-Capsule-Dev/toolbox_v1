#!/usr/bin/env bash
HARDINFO_PKGS=("hardinfo")

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
