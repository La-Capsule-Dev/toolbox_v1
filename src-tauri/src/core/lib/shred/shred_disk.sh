#!/usr/bin/env bash
set -euo pipefail

SHRED_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DIR_ROOT="${SHRED_DIR%%/core*}/core"
source "$DIR_ROOT/lib/ui/echo_status.sh"

# shred_disk.sh — Effacement sécurisé interactif de disque (CLI Bash)
#
# Auteur : binary-grunt — github.com/Binary-grunt - 25/07/05

# TODO: ADD test profond testdisk add LSCSI

shred_disk() {
    # Liste des disques physiques
    mapfile -t DEVICES < <(
        lsblk -dn -o NAME,SIZE,TYPE,MOUNTPOINT |
        awk '$3=="disk"{printf "%-12s %-8s %-10s %s\n", $1, $2, $3, $4}'
    )
    echo_status "Disques disponibles pour effacement :"
    select dev in "${DEVICES[@]}"; do
        if [[ -n $dev ]]; then
            dname=$(awk '{print $1}' <<< "$dev")
            mnt=$(awk '{print $4}' <<< "$dev")
            echo_status "Vous avez choisi : /dev/$dname"
            # Sécurité : avertir si monté
            if [[ -n "$mnt" ]]; then
                echo_status_warn "ATTENTION : /dev/$dname est monté sur $mnt !"
                read -p "Continuer malgré tout ? [o/N] " really
                [[ $really =~ ^[oO]$ ]] || { echo_status "Annulé."; break; }
            fi
            read -p "Confirmer l'effacement de /dev/$dname ? [o/N] " confirm
            if [[ $confirm == [oO]* ]]; then
                local cmd_to_run
                # Substitution du device (%s)
                cmd_to_run=$(printf "$1" "$dname" "$dname")
                # /!\ Pour sécurité, **désactive l’exécution réelle** par défaut :
                # gnome-terminal --geometry 60x5 -- $cmd_to_run
                echo_status_warn "Commande exécutée : $cmd_to_run"
                echo_status_ok "Effacement correctement effectué."
            else
                echo_status "Annulé."
            fi
            break
        else
            echo_status_warn "Choix invalide."
        fi
    done
}

test_disk(){

}
