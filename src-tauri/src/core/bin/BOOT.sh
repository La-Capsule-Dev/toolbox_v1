#!/usr/bin/env bash

set -euo pipefail

BIN_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DIR_ROOT="${BIN_DIR%%/core*}/core"

source "$DIR_ROOT/lib/utils/echo_status.sh"

booting_repair(){
    echo_status "Vérification des prérequis"
    if sudo apt update; then
        echo_status_ok "Update réussi"
    else
        echo_status_error "Échec de l'update apt"
    fi

    echo_status "Vérification du package boot-repair"
    if ! dpkg -s boot-repair &>/dev/null; then
        echo_status_warn "BOOTRepair non installé, installation en cours..."
        # Ajoute le ppa seulement s'il n'est pas déjà là
        if ! grep -h -R "yannubuntu/boot-repair" /etc/apt/sources.list /etc/apt/sources.list.d/* &>/dev/null; then
            sudo add-apt-repository -y ppa:yannubuntu/boot-repair
        fi
        sudo apt update
        if sudo apt install -y boot-repair; then
            echo_status_ok "Installation du package boot-repair réussie"
        else
            echo_status_error "Échec installation boot-repair"
        fi
    else
        echo_status_ok "BOOTRepair déjà installé"
    fi

    echo_status "Lancement de boot-repair"
    if boot-repair; then
        echo_status_ok "Boot-repair effectué"
    else
        echo_status_error "Erreur lors de l'exécution de boot-repair"
    fi
}

booting_repair


