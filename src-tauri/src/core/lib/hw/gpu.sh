#!/usr/bin/env bash

set -euo pipefail

# graphique_parser(){
#     sudo inxi -G | sed \
    #         -e "1d" \
    #         -e "s/  Device-1:/Modèle          :/" \
    #         -e "s/  Device-2:/Caméra          :/" \
    #         -e "s/  Message:/Message          :/" \
    #         -e "s/  OpenGL://" \
    #         -e "s/renderer:/\\nPilote          :/" \
    #         -e "s/  v:/Version         :/" \
    #         -e "s/driver: .*$//" \
    #         -e "s/Display: .*$//" \
    #         -e "s/resolution: .*$//" \
    #         -e "3,4d" \
    #         -e "s/  Graphics & Display//" \
    #         -e "s/  unloaded: fbdev,vesa//" \
    #         -e "/^[[:space:]]*$/d"
# }


graphique_parser() {
    sudo inxi -G | awk '
    /Device-[0-9]+:/    { sub(/.*Device-[0-9]+:/,"Modèle         :"); print; next }
    /renderer:/         { sub(/.*renderer:/,"Pilote         :"); print; next }
    /OpenGL:/           { sub(/.*OpenGL:/,"API            :"); print; next }
    /v:/                { sub(/.*v:/,"Version        :"); print; next }
    /Message:/          { sub(/.*Message:/,"Message        :"); print; next }
    /Display:/          { sub(/.*Display:/,"Affichage      :"); print; next }
    /connected/         { print "Sortie         :", $0; next }
    ' | awk -F':' '{ printf("%-14s : %s\n", $1, $2) }' | sed '/^[[:space:]]*:/d'
}

