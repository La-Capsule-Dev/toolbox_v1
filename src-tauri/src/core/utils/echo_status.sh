#!/usr/bin/env bash
set -euo pipefail

echo_status() {
    local text="$1"
    echo -e "\n\033[1;34m[ INFO ]\033[0m  $text\n"
}

echo_status_ok() {
    echo -e "\n\033[1;32m[ OK ]\033[0m    ✅ Opération réussie\n"
}

echo_status_error() {
    local text="$1"
    echo -e "\n\033[1;31m[ ERREUR ]\033[0m ❌ $text\n"
    exit 1
}
