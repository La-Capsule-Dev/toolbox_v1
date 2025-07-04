#!/usr/bin/env bash
export LANG=C.UTF-8
printf "\e[8;22;50t"
REQUIRED_GNOME=("gnome-terminal")
source "./../utils/loop-pkgs.sh"

install_pkgs REQUIRED_GNOME "gnome-terminal"
