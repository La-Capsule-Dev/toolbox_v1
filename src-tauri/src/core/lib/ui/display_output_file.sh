
#!/usr/bin/env bash

display_output_file() {
    local file="$1" h="${2:-10}" w="${3:-41}" t="${4:-Output}"
    dialog --backtitle "Linux Shell Script" --title "$t" --clear --msgbox "$(<"$file")" "$h" "$w"
}
