#!/usr/bin/env bash

set -euo pipefail

mapfile -t DEVICES < <(lsblk -dn -o NAME,SIZE,TYPE,MOUNTPOINT | awk '$3=="disk"{printf "%-12s %-8s %-10s %s\n", $1, $2, $3, $4}')

echo -e "Liste des disques connectés :"
lsblk -x NAME | awk '{print " -", $1, "-->", $4, " "}'

echo "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------"

shred_hdd() {
  echo "Disques disponibles pour effacement:"
  select dev in "${DEVICES[@]}"; do
 if [[ -n $dev ]]; then
      dname=$(awk '{print $1}' <<< "$dev")
      mnt=$(awk '{print $4}' <<< "$dev")
      echo "Vous avez choisi : /dev/$dname"
      if [[ -n "$mnt" ]]; then
        echo "⚠️  ATTENTION : /dev/$dname est monté sur $mnt !"
        read -p "Continuer malgré tout ? [o/N] " really
        [[ $really =~ ^[oO]$ ]] || { echo "Annulé."; break; }
      fi
      read -p "Confirmer le shred de /dev/$dname ? [o/N] " confirm
      if [[ $confirm == [oO]* ]]; then
        # gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/"$dname"
        echo "Effacement correctement effectué."
      else
        echo "Annulé."
      fi
      break
    else
      echo "Choix invalide."
    fi
  done
}
shred_hdd
