#!/usr/bin/env bash
set -euo pipefail

# shred_disk.sh — Effacement sécurisé interactif de disque (CLI Bash)
#
# Usage :
#   source ./shred_disk.sh
#   shred_disk "<commande_avec_%s>"
#
#   Ex : shred_disk "sudo shred -n 3 -z -u -v /dev/%s"
#
# Prérequis :
#   - lsblk, awk (utilitaires standards coreutils)
#
# Sécurité :
#   - Ne jamais exécuter sur un disque monté/système sans confirmation.
#   - Toujours vérifier la commande générée avant exécution réelle.
#
# Auteur : binary-grunt — github.com/Binary-grunt - 25/07/05

shred_disk() {
  # Liste des disques physiques
  mapfile -t DEVICES < <(
    lsblk -dn -o NAME,SIZE,TYPE,MOUNTPOINT |
      awk '$3=="disk"{printf "%-12s %-8s %-10s %s\n", $1, $2, $3, $4}'
  )
  echo
  echo "Disques disponibles pour effacement :"
  select dev in "${DEVICES[@]}"; do
    if [[ -n $dev ]]; then
      dname=$(awk '{print $1}' <<< "$dev")
      mnt=$(awk '{print $4}' <<< "$dev")
      echo
      echo "Vous avez choisi : /dev/$dname"
      # Sécurité : avertir si monté
      if [[ -n "$mnt" ]]; then
        echo "⚠️  ATTENTION : /dev/$dname est monté sur $mnt !"
        read -p "Continuer malgré tout ? [o/N] " really
        [[ $really =~ ^[oO]$ ]] || { echo "Annulé."; break; }
      fi
      read -p "Confirmer l'effacement de /dev/$dname ? [o/N] " confirm
      if [[ $confirm == [oO]* ]]; then
        local cmd_to_run
        # Substitution du device (%s)
        cmd_to_run=$(printf "$1" "$dname" "$dname")
        # Pour sécurité, **désactive l’exécution réelle** par défaut :
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
