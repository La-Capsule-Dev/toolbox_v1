#!/usr/bin/env bash
set -euo pipefail

UI_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

for file in "$UI_DIR"/*.sh; do
    [[ "$file" == "$UI_DIR/init.sh" ]] && continue
    source "$file"
done
