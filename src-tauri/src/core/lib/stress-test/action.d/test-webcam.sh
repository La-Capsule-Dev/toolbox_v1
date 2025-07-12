
function test_webcam
{
    # génération des menus pour la webCam.
    declare -a array

    i=1 #Index counter for adding to array
    j=1 #Option menu value generator

    while read line
    do
        array[ $i ]=$line
        (( j++ ))
        array[ ($i+1) ]=""
        (( i=($i+2) ))
    done < <(ls -l /dev/video* | grep -o -E "/dev/video." ) # l'entré vidéo

    #Define parameters for menu
    TERMINAL=$(tty) #Gather current terminal session for appropriate redirection
    HEIGHT=20
    WIDTH=76	# on remet en français
    export LANG=fr_FR.UTF-8

    #Build the menu with variables & dynamic content
    CHOICE=$(dialog --clear \
            --backtitle "$BACKTITLE" \
            --title "$TITLE" \
            --menu "$MENU" \
            $HEIGHT $WIDTH $CHOICE_HEIGHT \
            "${array[@]}" \
        2>&1 >$TERMINAL)

    sudo cheese $CHOICE
}
