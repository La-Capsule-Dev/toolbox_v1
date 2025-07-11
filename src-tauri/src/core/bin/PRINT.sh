#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DIR_ROOT="${BIN_DIR%%/core*}/core"
source "$DIR_ROOT/lib/utils/init.sh"
source "$DIR_ROOT/etc/template/entete-checklist.sh"
source "$DIR_ROOT/etc/template/bloc-info-machine.sh"

[[ "$(type -t afficher_entete_checklist)" == function ]] ||  echo_status_error "Fonction manquante"
[[ "$(type -t afficher_bloc_info_machine)" == function ]] || echo_status_error "Fonction manquante"

resultat=$(
    set -e
    afficher_entete_checklist
    afficher_bloc_info_machine
)

[[ -n "$resultat" ]] || echo_status_error "Aucune donnée produite"


pdf_print(){
    date="$(date '+%d-%m-%Y')"
    hour="$(date '+%H:%M:%S')"
    header="Fait le $date        Reconditionnement fait par :  _______________________________"
    outpdf="$HOME/resultat-$date-$hour.pdf"


    echo "$resultat" \
        | iconv -f utf-8 -t iso-8859-1 \
        | enscript --header="$header" --title='Sortie PDF' -X 88591 -o - \
        | ps2pdf - "$outpdf" \
        #| x-www-browser $outpdf
    #NOTE: décommenter en prod

}

pdf_print

