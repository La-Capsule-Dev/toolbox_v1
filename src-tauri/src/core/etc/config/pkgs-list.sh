#!/usr/bin/env bash
set -euo pipefail

# Chaque tableau = mapping de packages natifs par OS.

PKGS_DEBIAN=(
    acpi alsa-utils cheese curl dmidecode enscript ffmpeg glmark2 mesa-utils
    htop inxi libatasmart-bin nmon ghostscript sed smartmontools
    stress stress-ng s-tui upower mplayer
)
PKGS_ARCH=(
    acpi alsa-utils cheese curl dmidecode enscript ffmpeg glmark2 mesa-demos
    htop inxi libatasmart nmon ghostscript sed smartmontools
    stress stress-ng s-tui upower mplayer
)
PKGS_FEDORA=(
    acpi alsa-utils cheese curl dmidecode enscript ffmpeg glmark2 mesa-demos
    htop inxi libatasmart nmon ghostscript sed smartmontools
    stress stress-ng s-tui upower mplayer
)
PKGS_ALPINE=(
    acpi alsa-utils cheese curl dmidecode enscript ffmpeg glmark2 mesa-demos
    htop inxi libatasmart nmon ghostscript sed smartmontools
    stress stress-ng s-tui upower mplayer
)
PKGS_VOID=(
    acpi alsa-utils cheese curl dmidecode enscript ffmpeg glmark2 mesa-demos
    htop inxi libatasmart nmon ghostscript sed smartmontools
    stress stress-ng s-tui upower mplayer
)
PKGS_GENTOO=(
    acpi alsa-utils cheese curl dmidecode enscript ffmpeg glmark2 mesa-progs
    htop inxi libatasmart nmon ghostscript sed smartmontools
    stress stress-ng s-tui upower mplayer
)
PKGS_OPENSUSE=(
    acpi alsa-utils cheese curl dmidecode enscript ffmpeg glmark2 Mesa-demo-x
    htop inxi libatasmart nmon ghostscript sed smartmontools
    stress stress-ng s-tui upower mplayer
)
