#!/usr/bin/env bash
set -euo pipefail

# Batterie #
battery_parser(){
        sudo acpi -i | sed \
          -e "s/Full, /Chargée à /" \
          -e "s/Battery 0: //" \
          -e "s/Charging,/Chargement      :/" \
          -e "s/Discharging,/Déchargée à     :/" \
          -e "s/Unknow,/Inconnue        :/" \
          -e "s/%,/%\nTemps restant   :/" \
          -e "s/until charged//" \
          -e "s/design capacity/Capacité totale :/" \
          -e "s/mAh,/mAh\n/" \
          -e "s/ last full capacity/Capacité réelle :/" \
          -e "s/=/ soit environ/"
}

batmod_parser(){
  upower -i /org/freedesktop/UPower/devices/battery_BAT0 | awk 'NR>1 && NR< 5' | sed \
    -e "s/  vendor:               /Vendeur         : /" \
    -e "s/  model:                /Modèle          : /" \
    -e "s/  serial:               /Série           : /" \
    -e "s/  power supply:         no/Pas de batterie détectée/" \
    -e "s/  updated:         .*$//" \
    -e "s/  has history:          no//"
}
power_parser(){
  upower -i /org/freedesktop/UPower/devices/battery_BAT0 | awk /energy-full-design/,/voltage/ | sed \
    -e "s/    energy-full-design:  /Puissance       : /" \
    -e "s/    energy-rate:         /Taux            : /" \
    -e "s/    voltage:             /Tension         : /"
}
