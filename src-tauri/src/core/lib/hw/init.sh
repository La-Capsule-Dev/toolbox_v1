#!/usr/bin/env bash
set -euo pipefail

HARDWARE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

for file in "$HARDWARE_DIR"/*.sh; do
    [[ "$file" == "$HARDWARE_DIR/init.sh" ]] && continue
    source "$file"
done
