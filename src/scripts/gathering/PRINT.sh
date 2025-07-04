#!/usr/bin/env bash
set -euo pipefail

source "./entete_checklist.sh"
source "./bloc_info_machine.sh"

[[ "$(type -t afficher_entete_checklist)" == function ]] || { echo "Fonction manquante"; exit 1; }
[[ "$(type -t afficher_bloc_info_machine)" == function ]] || { echo "Fonction manquante"; exit 1; }

resultat=$(
  afficher_entete_checklist
  afficher_bloc_info_machine
)

echo "${resultat}" |  iconv -f utf-8 -t iso-8859-1 | 
enscript --header='Fait le $F        Reconditionnement fait par :  ________________________________' --title='Sortie PDF' -X 88591 -o - | 
ps2pdf - $HOME/resultat.pdf && x-www-browser $HOME/resultat.pdf
