#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/ui/echo_status.sh"

# shred_disk.sh — Effacement sécurisé interactif de disque (CLI Bash)
#
# Auteur : binary-grunt — github.com/Binary-grunt - 25/07/05


# TODO: ADD test profond testdisk add LSCSI

select_disk() {
    mapfile -t DEVICES < <(
        lsblk -dn -o NAME,SIZE,TYPE,MOUNTPOINT | \
            awk '$3=="disk"{print $1 " (" $2 ") " ($4==""?"-":$4)}'
    )
    echo "Sélectionnez un disque :" >&2    # <-- stderr uniquement
    select entry in "${DEVICES[@]}"; do
        [[ -n $entry ]] || { echo_status_warn "Choix invalide." >&2; continue; }
        local dname mnt
        dname=$(awk '{print $1}' <<< "$entry")
        mnt=$(awk '{print $3}' <<< "$entry")
        if [[ "$mnt" != "-" ]]; then
            echo_status_warn "ATTENTION : /dev/$dname est monté sur $mnt !" >&2
            read -p "Continuer quand même ? [o/N] " really
            [[ $really =~ ^[oO]$ ]] ||  echo_status_error "Annulé."
        fi
        echo "$dname"    # <-- stdout : seule cette ligne sera capturée
        return 0
    done
    return 1
}

# Exécute une commande disque (avec confirmation), template %s pour le nom du disque
run_disk_action() {
    local disk="$1" cmd_tmpl="$2"
    printf -v cmd "$cmd_tmpl" "$disk" "$disk"
    echo_status_warn "Commande à exécuter : $cmd"
    read -p "Confirmer exécution ? [o/N] " confirm
    [[ $confirm =~ ^[oO]$ ]] || { echo_status "Annulé."; return 1; }
    eval "$cmd"
    local ret=$?
    [[ $ret -eq 0 ]] && echo_status_ok "Opération réussie." || echo_status_error "Erreur d'exécution (code $ret)"
    return $ret
}


verify_disk() {
    local disk="$1"
    local dev_path="/dev/$disk"
    echo "Scan du disque $dev_path pour vérifier la présence de données résiduelles..."

    if [[ ! -b "$dev_path" ]]; then
        echo_status_error "Le périphérique $dev_path n'existe pas."
        return 1
    fi

    # On lit les 10 premiers MB pour limiter le scan (optionnel, retire le | head pour scan total)
    if sudo strings "$dev_path" | head -c 10485760 | grep -q .; then
        echo_status_warn "Des données lisibles subsistent sur $dev_path !"
        return 2
    else
        echo_status_ok "Aucune donnée lisible détectée (wipe OK)."
        return 0
    fi
}
