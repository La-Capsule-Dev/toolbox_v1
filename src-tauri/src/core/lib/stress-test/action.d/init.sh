#!/usr/bin/env bash
set -euo pipefail

STRESS_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

for file in "$STRESS_DIR"/*.sh; do
    [[ "$file" == "$STRESS_DIR/init.sh" ]] && continue
    source "$file"
done
