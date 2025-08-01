#!/usr/bin/env bash
set -euo pipefail

progress_bar() {
    local percent=$1
    local length=$2
    local filled=$(( percent * length / 100 ))
    local empty=$(( length - filled ))
    printf '[%s%s] %3d%%\r' \
        "$(printf '%*s' "$filled" | tr ' ' '-')" \
        "$(printf '%*s' "$empty")" \
        "$percent"
}

total=50         # ← Nombre d’unités à parcourir
total_duration=2 # ← Durée totale en secondes

sleep_time=$(awk "BEGIN{print $total_duration/$total}")

for ((i=0; i<=total; i++)); do
    percent=$(( i * 100 / total ))
    progress_bar "$percent" 30
    sleep "$sleep_time"
done
printf '\n'
