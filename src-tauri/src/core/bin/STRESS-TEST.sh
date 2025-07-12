#!/usr/bin/env bash
set -euo pipefail

# FIX:  3 - Battery dont work 
# 6 - Santé Disk crash
# 7 - Info Smart disk crash
# 10-11 Micro, Webcam
# 13 test clavier crash


#HACK: 8 - Stress CPU - à voir -> /tmp/post.txt
# 9 - Test USB  /tmp/usb_after.txt /tmp/usb_before.txt
# 12 - Test son A tester
# 14 - Test connexion marche ici -> ping.txt -> A voir


#NOTE: D
# toolbox.log
# [INFO]  2025-07-12 17:56:23 Analyse SMART sur /dev/zram0
# [WARN]  2025-07-12 17:56:23 SMART non supporté sur /dev/zram0
# [ERROR] 2025-07-12 17:56:23 Erreur d'exécution skdump (/dev/zram0): Failed to read SMART data: Operation not supported

# -- Utilitaires dialog --
msg() { dialog --msgbox "$1" 12 60; }
show_output() { dialog --title "$1" --msgbox "$(<"$2")" 20 60; }

# -- Sudo upfront --
get_sudo() { sudo -v || { msg "Mot de passe sudo invalide."; exit 1; }; }

# -- Fonctions Hardware --
ram_report()    { sudo inxi -m > /tmp/ram.txt;      show_output "Relevé RAM" /tmp/ram.txt; }
cpu_report()    { sudo inxi -C > /tmp/cpu.txt;      show_output "Relevé CPU" /tmp/cpu.txt; }
battery_report(){ sudo acpi -i > /tmp/batt.txt;     show_output "Batterie" /tmp/batt.txt; }
gpu_report()    { sudo inxi -G > /tmp/gpu.txt;      show_output "Info GPU" /tmp/gpu.txt; }
net_report()    { sudo inxi -N > /tmp/net.txt;      show_output "Info réseau" /tmp/net.txt; }
disk_smart()    { sudo smartctl -H /dev/sda > /tmp/smart.txt; show_output "SMART sda" /tmp/smart.txt; }
disk_health() {
    local disk
    disk=$(lsblk -ln -d -o NAME | grep -E "^sd" | dialog --menu "Disque ?" 20 60 10 $(awk '{print $1 " " $1}'))
    sudo skdump --overall /dev/"$disk" > /tmp/disk.txt
    show_output "Santé disque" /tmp/disk.txt
}
stress_cpu() {
    sudo inxi -s > /tmp/pre.txt
    show_output "Température de départ" /tmp/pre.txt
    sudo stress-ng --matrix 0 --ignite-cpu --log-brief --metrics-brief --times --tz --verify --timeout 15 -q
    sudo inxi -s > /tmp/post.txt
    show_output "Température après stress" /tmp/post.txt
}

# -- Tests plug & play --
usb_test() {
    lsusb > /tmp/usb_before.txt
    msg "Insérez un périphérique USB et validez."
    lsusb > /tmp/usb_after.txt
    local diffout
    diffout=$(diff /tmp/usb_before.txt /tmp/usb_after.txt | grep "ID" || true)
    if [[ -z "$diffout" ]]; then
        msg "Aucun périphérique détecté."
    else
        msg "Nouveau périphérique : $diffout"
    fi
}
mic_test() {
    local card dev
    arecord -l | grep "^  card" > /tmp/cards.txt || { msg "Aucune carte son."; return; }
    card=$(awk '{print $2}' /tmp/cards.txt | head -n1)
    dev=$(awk '{print $6}' /tmp/cards.txt | head -n1)
    [ -z "$card" ] && msg "Pas de carte son." && return
    local devstr="hw:${card},${dev}"
    msg "Appuyez pour enregistrer 3s au micro."
    arecord -f S16_LE -d 3 -c 1 --device="$devstr" /tmp/testmic.wav >/dev/null 2>&1
    mplayer /tmp/testmic.wav >/dev/null 2>&1 &
    msg "Lecture de l'enregistrement micro."
}
webcam_test() {
    local cam
    cam=$(ls /dev/video* 2>/dev/null | head -n1)
    [ -z "${cam:-}" ] && msg "Aucune webcam détectée." && return
    sudo cheese "$cam"
}
sound_test() {
    mplayer /usr/share/LACAPSULE/MULTITOOL/Test/test.wav >/dev/null 2>&1 &
    msg "Test du son lancé."
}
keyboard_test() { x-www-browser https://www.test-clavier.fr/; }

conn_test() {
    ping -c 2 www.google.fr -q > /tmp/ping.txt || { msg "Pas de réseau."; return; }
    curl -s -I www.google.fr | grep -q OK && msg "Connexion OK." || msg "Curl NOK."
}

# -- Menu principal extensible --
main_menu() {
    local choice
    while true; do
        choice=$(dialog --clear --title "Maintenance" \
            --menu "Sélectionnez une action" 22 70 18 \
            1 "Relevé RAM" \
            2 "Relevé CPU" \
            3 "Relevé batterie" \
            4 "Info GPU" \
            5 "Info réseau" \
            6 "Santé disque" \
            7 "Info SMART disque" \
            8 "Stress test CPU" \
            9 "Test USB (plug & play)" \
           10 "Test micro (plug & play)" \
           11 "Test webcam (plug & play)" \
           12 "Test son" \
           13 "Test clavier" \
           14 "Test connexion internet" \
           15 "Quitter" 3>&1 1>&2 2>&3) || break

        case $choice in
            1)  ram_report ;;
            2)  cpu_report ;;
            3)  battery_report ;;
            4)  gpu_report ;;
            5)  net_report ;;
            6)  disk_health ;;
            7)  disk_smart ;;
            8)  stress_cpu ;;
            9)  usb_test ;;
           10)  mic_test ;;
           11)  webcam_test ;;
           12)  sound_test ;;
           13)  keyboard_test ;;
           14)  conn_test ;;
           15)  break ;;
        esac
    done
}

# ----- MAIN -----
get_sudo
main_menu
