#!/usr/bin/env bash
set -euo pipefail

GATH_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DIR_ROOT="${GATH_DIR%%/core*}/core"
source "$DIR_ROOT/utils/logging.sh"
source "$GATH_DIR//fiche/entete_checklist.sh"
source "$GATH_DIR/fiche/bloc_info_machine.sh"


[[ "$(type -t afficher_entete_checklist)" == function ]] || { echo "Fonction manquante"; exit 1; }
[[ "$(type -t afficher_bloc_info_machine)" == function ]] || { echo "Fonction manquante"; exit 1; }

resultat=$(
    afficher_entete_checklist
    afficher_bloc_info_machine
)

echo "${resultat}" |  iconv -f utf-8 -t iso-8859-1 |
enscript --header='Fait le $F        Reconditionnement fait par :  ________________________________' --title='Sortie PDF' -X 88591 -o - |
ps2pdf - $HOME/resultat.pdf && x-www-browser $HOME/resultat.pdf
