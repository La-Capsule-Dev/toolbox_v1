#!/usr/bin/env bash
set -euo pipefail

function sudo_activate {

    # password storage
    data=$(tempfile 2>/dev/null)

    # trap it
    trap "rm -f $data" 0 1 2 5 15

    # get password
    dialog --title "Demande mot de passe root" \
        --clear \
        --insecure \
        --passwordbox "Saisissez votre mot de passe" 10 30 2> $data

    ret=$?

    # make decision
    case $ret in
        0)
            echo $(cat $data) | sudo -S -s ls >/dev/null ;;
        1)
            echo "Bye" ;;
        255)
            echo "Touche ESC appuyée."
    esac
}
