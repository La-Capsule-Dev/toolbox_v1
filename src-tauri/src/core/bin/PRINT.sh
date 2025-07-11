#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DIR_ROOT="${BIN_DIR%%/core*}/core"
source "$DIR_ROOT/lib/utils/init.sh"
source "$DIR_ROOT/etc/template/entete-checklist.sh"
source "$DIR_ROOT/etc/template/bloc-info-machine.sh"


[[ "$(type -t afficher_entete_checklist)" == function ]] ||  echo_statut_error "Fonction manquante"
[[ "$(type -t afficher_bloc_info_machine)" == function ]] || echo_status_error "Fonction manquante"

resultat=$(
    afficher_entete_checklist
    afficher_bloc_info_machine
)

echo "${resultat}" |  iconv -f utf-8 -t iso-8859-1 |
enscript --header='Fait le $F        Reconditionnement fait par :  ________________________________' --title='Sortie PDF' -X 88591 -o - |
ps2pdf - $HOME/resultat.pdf && x-www-browser $HOME/resultat.pdf
