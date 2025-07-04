#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/battery_info.sh"
source "$SCRIPT_DIR/display_info.sh"
source "$SCRIPT_DIR/gpu_info.sh"
source "$SCRIPT_DIR/network_info.sh"
source "$SCRIPT_DIR/ram_info.sh"
source "$SCRIPT_DIR/storage_info.sh"
source "$SCRIPT_DIR/system_info.sh"
