#!/usr/bin/env bash

set -euo pipefail

shopt -s nullglob
for f in "$SCRIPT_DIR"/hardware_info/*_info.sh; do
    [ -s "$f" ] && source "$f"
done
shopt -u nullglob
