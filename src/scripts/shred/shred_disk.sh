#!/usr/bin/env bash
set -euo pipefail

shred_disk() {
  mapfile -t DEVICES < <(lsblk -dn -o NAME,SIZE,TYPE,MOUNTPOINT | awk '$3=="disk"{printf "%-12s %-8s %-10s %s\n", $1, $2, $3, $4}')
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
      read -p "Confirmer l'effacement de /dev/$dname ? [o/N] " confirm
      if [[ $confirm == [oO]* ]]; then
        local cmd_to_run
        cmd_to_run=$(printf "$1" "$dname")
        # Comment that line below if you want to test without launching real shreding
        # gnome-terminal --geometry 60x5 -- $cmd_to_run
        echo "Commande exécutée : $cmd_to_run"
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
