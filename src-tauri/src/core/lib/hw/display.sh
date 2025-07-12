#!/usr/bin/env bash

set -euo pipefail

TARGET_ROOT="$TAURI_ROOT/target/release/dimension"

ecran_parser(){
    sudo xrandr |
    awk '/connected/' |
    sed -e "s/(.*$//" \
        -e "s/DVI-I/DVI/" \
        -e "s/Virtual-/Écran virtuel   /" \
        -e "s/eDP-1 /Écran intégré   : /" \
        -e "s/DP-1 /Port VGA        : /" \
        -e "s/HDMI-1 /Port HDMI       : /" \
        -e "s/disconnected/déconnecté$/" \
        -e "s/connected/connecté/" \
        -e "s/primary/principal$/"

}

taille_parser(){
    sudo $TARGET_ROOT || echo "$Erreur"
}

telecrante_parser(){
    sudo xrandr |
    awk '/connected/' |
    sed -e "s/(.*$//" \
        -e "s/VGA-1/Port VGA 1      :/" \
        -e "s/VGA-2/Port VGA 2      :/" \
        -e "s/DVI-I/DVI/" \
        -e "s/DVI-2/DVI-2/" \
        -e "s/Virtual-/Écran virtuel   :/" \
        -e "s/eDP-1/Écran intégré   :/" \
        -e "s/eDP-2/Écran virtuel   :/" \
        -e "s/DP-1/Port VGA        :/" \
        -e "s/DP-2/Port VGA 2      :/" \
        -e "s/HDMI-1/Port HDMI       :/" \
        -e "s/HDMI-2/Port HDMI 2     :/" \
        -e "s/disconnected/déconnecté/" \
        -e "s/connected/connecté/" \
        -e "s/primary/principal/"

}
