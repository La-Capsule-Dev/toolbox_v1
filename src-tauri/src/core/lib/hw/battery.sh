#!/usr/bin/env bash
set -euo pipefail

# Batterie
battery_parser() {
    local acpi_out
    acpi_out="$(sudo acpi -i 2>/dev/null || true)"

    # 1. Si aucune Battery détectée ou chaîne vide
    if [[ -z "$acpi_out" ]] || ! echo "$acpi_out" | grep -q "Battery"; then
        echo "Batterie        : Pas de batterie détectée"
        return
    fi

    # 2. Si la batterie est présente mais a des valeurs absurdes ou 0%
    local percent
    percent=$(echo "$acpi_out" | grep -oP '[0-9]+%' | head -n1 | tr -d '%')
    if [[ -z "$percent" || "$percent" == "0" ]]; then
        echo "Batterie        : Pas de batterie détectée"
        return
    fi

    # 3. Sinon, affiche tout le bloc
    echo "$acpi_out" | sed \
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

    # N'affiche les deux blocs suivants que si la batterie est réelle
    batmod_parser
    power_parser
}

batmod_parser() {
    upower -i /org/freedesktop/UPower/devices/battery_BAT0 2>/dev/null | awk 'NR>1 && NR< 5' | sed \
        -e "s/  vendor:               /Vendeur         : /" \
        -e "s/  model:                /Modèle          : /" \
        -e "s/  serial:               /Série           : /" \
        -e "s/  power supply:         no/Pas de batterie détectée/" \
        -e "s/  updated:         .*$//" \
        -e "s/  has history:          no//"
}

power_parser() {
    upower -i /org/freedesktop/UPower/devices/battery_BAT0 2>/dev/null | awk /energy-full-design/,/voltage/ | sed \
        -e "s/    energy-full-design:  /Puissance       : /" \
        -e "s/    energy-rate:         /Taux            : /" \
        -e "s/    voltage:             /Tension         : /"
}
