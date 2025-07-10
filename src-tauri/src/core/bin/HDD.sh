#!/usr/bin/env bash
set -euo pipefail

# HDD.sh — Utilitaire d’effacement sécurisé pour HDD/SATA classiques
#
# Usage :
#   ./HDD.sh
#
# Prérequis :
#   - lsblk, awk, sudo
#   - shred_disk.sh disponible dans le même dossier
#
# Sécurité :
#   - Affiche les disques connectés, aucune destruction sans confirmation.
#   - Simulation par défaut (décommentez dans shred_disk.sh pour activer l’effacement réel)
#
# Auteur : binary-grunt — github.com/Binary-grunt - 25/07/05

BIN_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DIR_ROOT="${BIN_DIR%%/core*}/core"

# -- Vérification des dépendances --
for cmd in lsblk awk sudo; do
    command -v "$cmd" >/dev/null || { echo "Erreur : $cmd non trouvé"; exit 1; }
done

# -- Affichage de la liste des disques --
echo -e "Liste des disques connectés :"
lsblk -x NAME | awk '{print " -", $1, "-->", $4, " "}'
echo "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------"

# -- Menu interactif d’effacement sécurisé --
source "$DIR_ROOT/lib/shred/shred_disk.sh"

# Commande shred standard adaptée aux disques classiques (simulation par défaut)
shred_disk "sudo shred -n 3 -z -u -v /dev/%s"
