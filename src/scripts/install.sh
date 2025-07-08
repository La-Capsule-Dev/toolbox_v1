#!/usr/bin/env bash

PKGS_TO_INSTALL=(
    # Système et monitoring hardware
    acpi arecord cheese dmidecode hardinfo htop inxi nmon powerstat smartctl
    smartmontools upower

    # Réseau et analyse
    iptraf-ng

    # Affichage/graphique
    glmark2 glxgears screentest xrandr

    # Audio/vidéo
    alsa-utils enscript ffmpeg mplayer

    # CLI utilitaires de base
    curl dialog iconv ps2pdf sed s-tui stress stress-ng tr

    # Divers et benchmarks
    libatasmart-bin

    # Autres
    skdump
)


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
