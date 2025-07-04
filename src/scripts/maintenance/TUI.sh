#!/usr/bin/env bash
export LANG=C.UTF-8
printf "\e[8;22;50t"
REQUIRED_GNOME=("gnome-terminal")

#TODO: To refactor in loop-pkgs
for REQUIRED_PKG in "${REQUIRED_GNOME[@]}"; do
 PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG)
 echo "Checking for $REQUIRED_PKG: $PKG_OK"
 if ! dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG | grep -q "Le paquet est bien installé"; then
   echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
   sudo apt-get --yes install $REQUIRED_PKG &&
   gnome-terminal -- '/usr/share/LACAPSULE/MULTITOOL/bootstrap.sh'
 fi
done
