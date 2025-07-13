#!/usr/bin/env bash
set -euo pipefail

# HDD.sh — Utilitaire d’effacement sécurisé pour HDD/SATA classiques
#
# Auteur : binary-grunt — github.com/Binary-grunt - 25/07/05

source "$CORE_DIR/etc/config/path.env"
source "$LIB_DIR/ui/echo_status.sh"
source "$LIB_DIR/shred/shred_hdd.sh"
source "$LIB_DIR/shred/shred_nvme.sh"

shred_nvme
