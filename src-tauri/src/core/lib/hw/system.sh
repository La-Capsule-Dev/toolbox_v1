#!/usr/bin/env bash

set -euo pipefail

arch_get(){
    case "$(uname -m)" in
        x86_64) echo "x86_64" ;;
        aarch64) echo "arm64" ;;
        *) echo "unknown" ;;
    esac
}

marque_get(){
    if ! command -v dmidecode &>/dev/null; then
        echo "dmidecode requis pour obtenir la marque du système"
        return 1
    fi
    sudo dmidecode -s system-manufacturer
}

model_get(){
    if ! command -v dmidecode &>/dev/null; then
        echo "dmidecode requis pour obtenir le modèle du système"
        return 1
    fi

    sudo dmidecode -s system-product-name
}

serial_get(){
    if ! command -v dmidecode &>/dev/null; then
        echo "dmidecode requis pour obtenir le numéro de série du système"
        return 1
    fi

    # Utilisation de sudo pour obtenir le numéro de série
    sudo dmidecode -s system-serial-number
}


cpu_parser(){
    if ! command -v inxi &>/dev/null; then
        echo "inxi requis pour obtenir les informations du processeur"
        return 1
    fi

    inxi -C | sed \
        -e "s/CPU: //g" \
        -e "s/Model name:/Modèle   :/" \
        -e "s/Speed:/Fréquence :/" \
        -e "s/Core Count:/Nombre de cœurs :/" \
        -e "s/Thread Count:/Nombre de threads :/"
}
