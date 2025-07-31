#!/usr/bin/env bash
set -euo pipefail

source "$CORE_DIR/etc/config/path.env"

run_hardinfo() {
    local tool=""
    if command -v hardinfo >/dev/null 2>&1; then
        tool="hardinfo"
    elif command -v hardinfo2 >/dev/null 2>&1; then
        tool="hardinfo2"
    else
        echo "hardinfo introuvable après installation." >&2

    fi
    exec "$tool"
}

run_hardinfo
