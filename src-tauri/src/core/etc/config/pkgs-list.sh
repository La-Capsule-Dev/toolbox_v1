#!/usr/bin/env bash
set -euo pipefail

# Chaque tableau = mapping de packages natifs par OS.
# Tu importes SEULEMENT celui qui correspond à l’OS courant dans tes scripts.

PKGS_DEBIAN=(
    acpi alsa-utils cheese curl dialog dmidecode enscript ffmpeg glmark2 mesa-utils
    hardinfo htop inxi libatasmart-bin nmon ghostscript sed smartmontools
    stress stress-ng s-tui upower x11-xserver-utils
)
PKGS_ARCH=(
    acpi alsa-utils cheese curl dialog dmidecode enscript ffmpeg glmark2 mesa-demos
    hardinfo htop inxi libatasmart nmon ghostscript sed smartmontools
    stress stress-ng s-tui upower xorg-xdpyinfo
)
PKGS_FEDORA=(
    acpi alsa-utils cheese curl dialog dmidecode enscript ffmpeg glmark2 mesa-demos
    hardinfo htop inxi libatasmart nmon ghostscript sed smartmontools
    stress stress-ng s-tui upower xorg-x11-utils
)
PKGS_ALPINE=(
    acpi alsa-utils cheese curl dialog dmidecode enscript ffmpeg glmark2 mesa-demos
    hardinfo htop inxi libatasmart nmon ghostscript sed smartmontools
    stress stress-ng s-tui upower xorg-xdpyinfo
)
PKGS_VOID=(
    acpi alsa-utils cheese curl dialog dmidecode enscript ffmpeg glmark2 mesa-demos
    hardinfo htop inxi libatasmart nmon ghostscript sed smartmontools
    stress stress-ng s-tui upower xorg-xdpyinfo
)
PKGS_GENTOO=(
    acpi alsa-utils cheese curl dialog dmidecode enscript ffmpeg glmark2 mesa-progs
    hardinfo htop inxi libatasmart nmon ghostscript sed smartmontools
    stress stress-ng s-tui upower xdpyinfo
)
PKGS_OPENSUSE=(
    acpi alsa-utils cheese curl dialog dmidecode enscript ffmpeg glmark2 Mesa-demo-x
    hardinfo htop inxi libatasmart nmon ghostscript sed smartmontools
    stress stress-ng s-tui upower xorg-x11-utils
)
