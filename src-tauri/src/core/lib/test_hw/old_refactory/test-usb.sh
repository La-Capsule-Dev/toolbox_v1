
function test_usb()
{
    lsusb > /tmp/usbBefore

    echo "veuillez insérer un périphérique USB" > $OUTPUT
    display_output 20 60 "Message"

    lsusb > /tmp/usbAfter

    marque=$(diff /tmp/usbBefore /tmp/usbAfter | grep ID | cut -d " " -f 8-100)



    if [ -z "$marque" ]
    then
        echo "Le port USB ne fonctionne pas ou aucun périphérique inseré" > $OUTPUT
        display_output 20 60 "Message"
    else
        echo "Le périphérique usb inseré est : $marque" > $OUTPUT
        display_output 20 60 "Message"
    fi

    dialog --backtitle "choix" --title "demande d'une réponse" \
        --yesno "

    Souhaitez-vous tester un nouveau port USB ? " 12 60

    if [ $? = 0 ]
    then
        test_usb
    else
        return
    fi

}

