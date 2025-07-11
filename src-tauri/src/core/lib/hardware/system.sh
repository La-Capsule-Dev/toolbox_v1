#!/usr/bin/env bash

set -euo pipefail

arch_get(){
    uname -m
}

marque_get(){
    sudo dmidecode -s system-manufacturer
}

model_get(){
    sudo dmidecode -s system-product-name
}

serial_get(){
    sudo dmidecode -s system-serial-number
}

cpu_parser(){
    cat /proc/cpuinfo | sed "s/model name/Modèle   /" | sed -n 5p
}
