#!/usr/bin/env bash

set -euo pipefail

getval() {
    local val
    val="$($1 2>/dev/null || true)"
    [[ -z "$val" ]] && echo "N/A" || echo "$val"
}

batterie_block=$(getval battery_parser)
ecran=$(getval ecran_parser)
taille=$(getval taille_parser)
telecrante=$(getval telecrante_parser)
graphique=$(getval graphique_parser)
mem=$(getval mem_parser)
reseau=$(getval reseau_parser)
arch=$(getval arch_get)
cpu_model=$(getval cpu_parser)
disque=$(getval disque_parser)
marque=$(getval marque_get)
model=$(getval model_get)
serial=$(getval serial_get)
