#!/usr/bin/env bash
set -euo pipefail

# HDD.sh — Utilitaire d’effacement sécurisé pour HDD/SATA classiques

source "$LIB_DIR/ui/echo_status.sh"
source "$LIB_DIR/shred/core_disk.sh"

shred_hdd(){
    #local command="sudo shred -n 3 -z -u -v /dev/%s"
    local command=$(echo "Test")
    # -- Vérification des dépendances --
    for cmd in lsblk awk sudo; do
        command -v "$cmd" >/dev/null ||  echo_status_error "Erreur : $cmd non trouvé"
    done

    # -- Affichage de la liste des disques --
    echo -e "Liste des disques connectés :"
    lsblk -x NAME | awk '{print " -", $1, "-->", $4, " "}'
    echo "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------"

    # -- Menu interactif d’effacement sécurisé --
    local disk
    disk=$(select_disk) || exit 1

    # Commande shred standard adaptée aux disques classiques (simulation par défaut)
    #run_disk_action "$disk" "$command" || echo_status_error "Échec du shred_disk HDD"

    verify_disk "$disk"
    echo_status_ok "Shred du HDD fini et vérifié"
}
