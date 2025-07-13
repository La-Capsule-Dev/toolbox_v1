
function autoMenuDisque(){
    declare -a array

    i=1 #Index counter for adding to array
    j=1 #Option menu value generator

    while read line
    do
        array[ $i ]=$line
        (( j++ ))
        array[ ($i+1) ]=""
        (( i=($i+2) ))

    done < <(lsblk -l -d | grep sd | cut -d " " -f 1) # selectionne les disques

    #Define parameters for menu
    TERMINAL=$(tty) #Gather current terminal session for appropriate redirection
    HEIGHT=20
    WIDTH=76
    CHOICE_HEIGHT=16
    BACKTITLE="Back_Title"
    TITLE="Disque"
    MENU="Choisissez le disque (si usb sdb):"

    #Build the menu with variables & dynamic content
    CHOICE=$(dialog --clear \
            --backtitle "$BACKTITLE" \
            --title "$TITLE" \
            --menu "$MENU" \
            $HEIGHT $WIDTH $CHOICE_HEIGHT \
            "${array[@]}" \
        2>&1 >$TERMINAL)
}
