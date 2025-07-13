#!/usr/bin/env bash
set -euo pipefail

# HDD.sh — Utilitaire d’effacement sécurisé pour HDD/SATA classiques
#
# Auteur : binary-grunt — github.com/Binary-grunt - 25/07/05

source "$CORE_DIR/etc/config/path.env"
source "$LIB_DIR/ui/echo_status.sh"

shred_hdd(){
    # -- Vérification des dépendances --
    for cmd in lsblk awk sudo; do
        command -v "$cmd" >/dev/null ||  echo_status_error "Erreur : $cmd non trouvé"
    done

    # -- Affichage de la liste des disques --
    echo -e "Liste des disques connectés :"
    lsblk -x NAME | awk '{print " -", $1, "-->", $4, " "}'
    echo "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------"

    # -- Menu interactif d’effacement sécurisé --
    source "$DIR_ROOT/lib/shred/shred_disk.sh"

    # Commande shred standard adaptée aux disques classiques (simulation par défaut)
    shred_disk "sudo shred -n 3 -z -u -v /dev/%s" || echo_status_error "Échec du shred_disk HDD"

    echo_status_ok "Shred du HDD fini et réussi"
}

shred_hdd
