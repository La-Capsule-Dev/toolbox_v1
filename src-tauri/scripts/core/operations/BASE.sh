#!/usr/bin/env bash
set -euo pipefail

base(){
    printf '\e[8;1;1t'
    x-www-browser 'https://gest.goupil-ere.org'
}
base
