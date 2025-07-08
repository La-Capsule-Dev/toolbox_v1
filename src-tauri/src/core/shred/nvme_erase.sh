#!/usr/bin/env bash
set -euo pipefail

# nvme_erase.sh — Menu d’effacement sécurisé des disques NVMe (CLI Bash)
#
# Usage :
#   ./nvme_erase.sh
#
# Prérequis :
#   - nvme-cli, lsblk, awk, sudo
#   - shred_disk.sh dans le même dossier (source)
#
# Sécurité :
#   - Affiche les disques détectés avant toute opération.
#   - Aucune destruction réelle sans modification explicite (simulation par défaut).
#
# Auteur : binary-grunt — github.com/Binary-grunt - 25/07/05

# -- Vérification des dépendances --
for cmd in nvme lsblk awk sudo; do
    command -v "$cmd" >/dev/null || { echo "Erreur : $cmd non trouvé"; exit 1; }
done
# -- Affichage du contexte matériel --
echo -e "Référence des disques NVMe connectés :"
nvme list || echo "(Aucun NVMe détecté)"
echo "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "Liste des disques connectés :"
lsblk -x NAME | awk '{print " -", $1, "-->", $4, " "}'
echo "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------"

# -- Menu interactif d’effacement sécurisé --
source "./shred_disk.sh"

# Commande d’effacement adaptée aux NVMe : (simulation, à activer explicitement)
shred_disk "sudo nvme format -s2 /dev/%s && sudo blkdiscard /dev/%s"
