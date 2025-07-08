#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DIR_ROOT="${SCRIPT_DIR%%/core*}/core"
source "$DIR_ROOT/utils/logging.sh"
source "$DIR_ROOT/utils/project_root.sh"
source "$SCRIPT_DIR//fiche/entete_checklist.sh"
source "$SCRIPT_DIR/fiche/bloc_info_machine.sh"


PROJECT_ROOT=$(find_project_root)


[[ "$(type -t afficher_entete_checklist)" == function ]] || { echo "Fonction manquante"; exit 1; }
[[ "$(type -t afficher_bloc_info_machine)" == function ]] || { echo "Fonction manquante"; exit 1; }

resultat=$(
    afficher_entete_checklist
    afficher_bloc_info_machine
)

echo "${resultat}" |  iconv -f utf-8 -t iso-8859-1 |
enscript --header='Fait le $F        Reconditionnement fait par :  ________________________________' --title='Sortie PDF' -X 88591 -o - |
ps2pdf - $HOME/resultat.pdf && x-www-browser $HOME/resultat.pdf
