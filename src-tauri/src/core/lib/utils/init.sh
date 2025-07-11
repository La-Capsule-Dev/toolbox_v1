#!/usr/bin/env bash
set -euo pipefail

UTILS_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

for file in "$UTILS_DIR"/*.sh; do
    [[ "$file" == "$UTILS_DIR/init.sh" ]] && continue
    source "$file"
done
