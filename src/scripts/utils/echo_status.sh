#!/usr/bin/env bash
set -euo pipefail

echo_status(){
    local text="$1"

    echo ""
    echo "$text"
    echo ""
}

echo_status_ok(){
    local text="                      ✅ OK ✅"

    echo ""
    echo "$text"
    echo ""
}

