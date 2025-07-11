#!/usr/bin/env bash
set -euo pipefail

: "${NO_EMOJI:=0}"

emj_ok=${NO_EMOJI:+""}
emj_info=${NO_EMOJI:+""}
emj_err=${NO_EMOJI:+""}
emj_warn=${NO_EMOJI:+""}

if [[ $NO_EMOJI -eq 0 ]]; then
    emj_ok="✅"
    emj_info="ℹ️"
    emj_err="❌"
    emj_warn="⚠️"
fi

echo_status() {
    local text="$1"
    echo -e "\n\033[1;34m[ INFO ]\033[0m $emj_info $text\n"
}

echo_status_ok() {
    local text="$1"
    echo -e "\n\033[1;32m[ OK ]\033[0m $emj_ok $text\n"
}

echo_status_warn() {
    local text="$1"
    echo -e "\n\033[1;33m[ WARN ]\033[0m $emj_warn $text\n"
}

echo_status_error() {
    local text="$1"
    echo -e "\n\033[1;31m[ ERREUR ]\033[0m $emj_err $text\n" >&2
    exit 1
}
