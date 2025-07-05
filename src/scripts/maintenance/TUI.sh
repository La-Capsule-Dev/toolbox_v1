#!/usr/bin/env bash
set -euo pipefail
export LANG=C.UTF-8

install_tui(){

REQUIRED_GNOME=("gnome-terminal")
printf "\e[8;22;50t"
source "./../utils/loop-pkgs.sh"

install_pkgs REQUIRED_GNOME "gnome-terminal"

}

install_tui
