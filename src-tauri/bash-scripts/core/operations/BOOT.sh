#!/usr/bin/env bash

#HACK: Improve later
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/echo_status.sh"

booting_repair(){
    echo_status "             Vérification des prérequis "
    sudo apt update && echo_status_ok
    echo_status "        Installation du paquet BOOTRepair "

    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' boot-repair | grep "Le logiciel est bien installé")
    if [ "" = "$PKG_OK" ]; then
        echo "BOOTRepair n'est pas installé, installation en cours..."
        sudo add-apt-repository ppa:yannubuntu/boot-repair
        sudo apt install boot-repair
    fi

    echo_status "            Lancement de BOOT REPAIR "
    boot-repair
    echo_status "                      Ouverture..."
    boot-repair
}

booting_repair


