#!/usr/bin/env bash

BIN_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DIR_ROOT="${BIN_DIR%%/core*}/core"

source "$DIR_ROOT/etc/config/pkgs.sh"
source "$DIR_ROOT/lib/utils/echo_status.sh"

install(){
    echo_status "Voulez-vous installer les dépendances nécessaires ? (Oui/Non)"
    read reponse

    if [[ "$reponse" =~ ^([oO][uU][iI]|[oO])$ ]]; then
        sudo apt update && echo_status_ok "Update réussi" || echo_status_error "Échec de l'update"


        echo "Vérification de la disponibilité des paquets :"
        > missing_pkgs.txt
        for pkg in "${PKGS[@]}"; do
            if ! apt-cache show "$pkg" >/dev/null 2>&1; then
                echo "$pkg" >> missing_pkgs.txt
            fi
        done

        # 2. Installer uniquement si absent
        for pkg in "${PKGS[@]}"; do
            if dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q "install ok installed"; then
                echo_status_ok "$pkg est déjà installé."
            else
                echo_status "🔧 Installation de $pkg ..."
                sudo apt-get --yes install "$pkg"
            fi
        done
        echo_status_ok "Installation des dépendances nécessaires réussie"
    else
        echo_status_error "L'installation des dépendances a été annulée."
    fi
}

install
