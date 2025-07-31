#!/usr/bin/env bash
set -euo pipefail


################################################################################
# Simple, maintainable CPU stress-test + live temperature monitoring in Bash.
# - Only dependencies: inxi, stress-ng, awk, bc
# - Clean design, readable, fully commented, easy to adapt/extend.
# - Robust against inxi output variations (assumes "cpu: NNN" always present).
################################################################################

# ---- Color codes for TUI output ----------------------------------------------
RED='\033[1;31m'
YEL='\033[1;33m'
CYN='\033[1;36m'
GRN='\033[1;32m'
BLU='\033[1;34m'
BOLD='\033[1m'
RESET='\033[0m'

# ---- Configurable parameters -------------------------------------------------
DURATION=80  # seconds to stress
INTERVAL=1   # seconds between temperature reads
BAR_CHAR="#" # Graph character (ASCII only for full compatibility)

# ---- Print a boxed title (TUI-style) -----------------------------------------
print_boxed_title() {
    local title="$1"
    local width=${2:-46}
    printf "\n${BOLD}${BLU}╔"
    printf '═%.0s' $(seq 1 $width)
    printf "╗\n"
    printf "%s\n" "       $title"
    printf "╚"
    printf '═%.0s' $(seq 1 $width)
    printf "╝${RESET}\n"
}

# ---- Parse CPU temperature from 'inxi -s' output -----------------------------
# Returns float value, no "°", never empty (or empty string if not found)
get_cpu_temp() {
    # Defensive: always parse field right after "cpu:" label.
    inxi -s | awk '/cpu:/ {for (i=1; i<NF; i++) if ($i=="cpu:") {print $(i+1); exit}}'
}

# ---- Display CPU information (from inxi -C) ----------------------------------
print_cpu_info() {
    printf "${CYN}%s${RESET}\n" "$1"
}

# ---- Render one line of the live table ---------------------------------------
print_live_line() {
    local second="$1"
    local curr="$2"
    local max="$3"
    local barlen="$4"
    local is_new_max="$5"
    local color_graph="$YEL"
    [[ "$is_new_max" == "1" ]] && color_graph="$RED"
    bar=$(printf "%${barlen}s" "" | tr " " "$BAR_CHAR")
    printf "${GRN}%6s${RESET} │ ${CYN}%7s°C${RESET} │ ${RED}%7s°C${RESET} │ ${color_graph}%s${RESET}\n" \
        "$second" "$curr" "$max" "$bar"
}

# ---- Print live table header -------------------------------------------------
print_table_header() {
    printf "${YEL}%6s │ %8s  │ %8s  │ %s${RESET}\n" "Second" "Temp" "Max" "Graphique"
    printf "${YEL}───────┼───────────┼───────────┼───────────────────────────────────────────────${RESET}\n"
}

# ---- Print summary after test -----------------------------------------------
print_summary() {
    print_boxed_title "RÉSUMÉ" 46
    printf "${CYN}Température avant traitement :${RESET} %s°C\n" "$1"
    printf "${RED}Temp max atteinte            :${RESET} %s°C\n" "$2"
    printf "${GRN}Temp après traitement        :${RESET} %s°C\n" "$3"
    echo
}

# ---- Main routine ------------------------------------------------------------
cpu_report() {
    # Capture initial info
    local cpu_data temp_start temp_end max_temp curr_temp
    cpu_data="$(inxi -C)"
    temp_start="$(get_cpu_temp)"

    printf '\n'
    print_boxed_title "TEST STRESS CPU & TEMP LIVE" 46
    printf "${CYN}Température avant traitement :${RESET} %s°C\n" "$temp_start"
    print_cpu_info "$cpu_data"
    echo

    # Sudo upfront to avoid password prompt in loop
    sudo -v

    # Launch stress-ng in background
    sudo stress-ng --matrix 0 --ignite-cpu --log-brief --metrics-brief \
        --times --tz --verify --timeout $DURATION -q &

    local stress_pid=$!
    sleep 1  # Give stress-ng time to start

    print_table_header

    # Initialize tracking
    max_temp="$temp_start"
    local i=1
    while (( i <= DURATION )); do
        if ! kill -0 "$stress_pid" 2>/dev/null; then
            printf "${RED}(stress-ng terminé)${RESET}\n"
            break
        fi

        curr_temp="$(get_cpu_temp)"
        # Fallback if temp not found (rare)
        if [[ -z "$curr_temp" ]]; then sleep "$INTERVAL"; ((i++)); continue; fi

        # Update max temperature
        local is_new_max=0
        if (( $(echo "$curr_temp > $max_temp" | bc -l) )); then
            max_temp="$curr_temp"
            is_new_max=1
        fi

        # Length of the bar is proportional to temp increase since start
        local barlen
        barlen=$(awk -v c="$curr_temp" -v s="$temp_start" 'BEGIN {d=int(c-s); print (d>0)?d:0}')
        print_live_line "$i" "$curr_temp" "$max_temp" "$barlen" "$is_new_max"
        sleep "$INTERVAL"
        ((i++))
    done

    wait "$stress_pid" || true

    temp_end="$(get_cpu_temp)"
    print_summary "$temp_start" "$max_temp" "$temp_end"
}

