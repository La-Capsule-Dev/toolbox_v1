#!/usr/bin/env bash

set -euo pipefail

graphique_parser(){
  sudo inxi -G | sed \
    -e "1d" \
    -e "s/  Device-1:/Modèle          :/" \
    -e "s/  Device-2:/Caméra          :/" \
    -e "s/  Message:/Message          :/" \
    -e "s/  OpenGL://" \
    -e "s/renderer:/\\nPilote          :/" \
    -e "s/  v:/Version         :/" \
    -e "s/driver: .*$//" \
    -e "s/Display: .*$//" \
    -e "s/resolution: .*$//" \
    -e "3,4d" \
    -e "s/  Graphics & Display//" \
    -e "s/  unloaded: fbdev,vesa//" \
    -e "/^[[:space:]]*$/d" 
}
