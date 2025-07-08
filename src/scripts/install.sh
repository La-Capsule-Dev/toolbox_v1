#!/usr/bin/env bash

PKGS_TO_INSTALL=("dmidecode" "dialog" "sed" "tr" "smartmontools" "skdump" "inxi" "acpi" "xrandr" "python3" "iconv" "enscript" "ps2pdf" "htop" "upower" "hardinfo" "arecord" "mplayer" "cheese" "arecord" "ffmpeg" "mplayer" "alsautils" "curl" "glxgears" "glmark2" "screentest" "libatasmart-bin" "smartctl" "nmon" "iptraf-ng" "s-tui" "stress-ng" "stress")


echo "Voulez-vous installer les dépendances nécessaires ? (Oui/Non)"
read reponse

if [[ "$reponse" =~ ^([oO][uU][iI]|[oO])$ ]]; then
    sudo apt update

    echo "Vérification de la disponibilité des paquets :"
    for pkg in "${PKGS_TO_INSTALL[@]}"; do
        if ! apt-cache show "$pkg" >/dev/null 2>&1; then
            echo "$pkg" >> missing_pkgs.txt
        fi
    done

    # 2. Installer uniquement si absent
    for pkg in "${PKGS_TO_INSTALL[@]}"; do
        if dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q "install ok installed"; then
            echo "✔ $pkg est déjà installé."
        else
            echo "🔧 Installation de $pkg ..."
            sudo apt-get --yes install "$pkg"
        fi
    done

    echo "Packet manquant/absent"
    nano missing_pkgs.txt
else
    echo "L'installation des dépendances a été annulée."
fi
