#!/usr/bin/env bash
set -euo pipefail

function test_micro
{
    # on passe en anglais
    export LANG=en.UTF-8

    # génération des menus pour la carte son.
    declare -a array

    i=1 #Index counter for adding to array
    j=1 #Option menu value generator

    while read line
    do
        array[ $i ]=$line
        (( j++ ))
        array[ ($i+1) ]=""
        (( i=($i+2) ))
    done < <(arecord -l | grep card ) # selectionne les disques

    #Define parameters for menu
    TERMINAL=$(tty) #Gather current terminal session for appropriate redirection
    HEIGHT=20
    WIDTH=76
    CHOICE_HEIGHT=16
    BACKTITLE="Back_Title"
    TITLE="Carte Son"
    MENU="Choisissez la carte son :"

    #Build the menu with variables & dynamic content
    CHOICE=$(dialog --clear \
            --backtitle "$BACKTITLE" \
            --title "$TITLE" \
            --menu "$MENU" \
            $HEIGHT $WIDTH $CHOICE_HEIGHT \
            "${array[@]}" \
        2>&1 >$TERMINAL)

    export LANG=fr_FR.UTF-8

    echo "Appuyer sur Accepter pour commencer l'enregistrement de 10 s " > $OUTPUT
    display_output 20 60 "Enregistrement"

    # On récupère les données que l'on veut.
    card=$(echo $CHOICE | grep -E -o "card.{0,2}" | cut -d " " -f2 )
    device=$(echo $CHOICE | grep -E -o "device.{0,2}" | cut -d " " -f2 )

    fullDevice="hw:${card},${device}"

    # enregistre pendant 10 s
    arecord -f S16_LE -d 10 -c 2 --device="$fullDevice" /tmp/test-mic.wav >/dev/null 2>&1 &

    DIALOG=${DIALOG=dialog}
    COUNT=0
    (
        while test $COUNT != 100
        do
            echo $COUNT
            echo "XXX"
            echo "enregistrement"
            echo "XXX"
            COUNT=`expr $COUNT + 10`
            sleep 1
        done
    ) |

    $DIALOG --title "Enregistrement micro" --gauge "Temps(s)" 20 70 0

    mplayer /tmp/test-mic.wav >/dev/null 2>&1 &

    DIALOG=${DIALOG=dialog}
    COUNT=0
    (
        while test $COUNT != 100
        do
            echo $COUNT
            echo "XXX"
            echo "Lecture de l'enregistrement"
            echo "XXX"
            COUNT=`expr $COUNT + 10`
            sleep 1
        done
    ) |
    $DIALOG --title "Lecture de l'enregistement" --gauge "Temps(s)" 20 70 0
}
