#!/usr/bin/env bash
set -euo pipefail

check_cmos_battery() {
    local sys_time rtc_time diff msg
    sys_time=$(date +%s)
    rtc_time=$(sudo hwclock --get | date +%s -f -)
    diff=$(( sys_time > rtc_time ? sys_time - rtc_time : rtc_time - sys_time ))

    if (( diff > 86400 )); then
        msg="⚠️  Avertissement :\nL'horloge matérielle (RTC/BIOS) diffère de l'heure système de plus de 24h !\n"
        msg+="Pile CMOS probablement HS ou jamais réglée.\n\n"
        msg+="hwclock : $(sudo hwclock)\n"
        msg+="system  : $(date)"
    else
        msg="OK : Horloge matérielle et système cohérentes.\n\n"
        msg+="hwclock : $(sudo hwclock)\n"
        msg+="system  : $(date)"
    fi

    whiptail --title "Diagnostic pile CMOS/RTC" --msgbox "$msg" 14 70
}
