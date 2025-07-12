
function stressCPU(){
    #nbCore=$(cat /proc/cpuinfo | uniq | cut -d " " -f 3)

    sudo inxi -s > $OUTPUT
    display_output 20 60 "Température de départ"
    DIALOG=${DIALOG=dialog}

    sudo stress-ng --matrix 0 --ignite-cpu --log-brief --metrics-brief --times --tz --verify --timeout 190 -q &

    COUNT=0
    (
        while test $COUNT != 100
        do
            echo $COUNT
            echo "XXX"
            inxi -s
            echo "XXX"
            COUNT=`expr $COUNT + 1`
            sleep 1.8
        done
    ) |

    $DIALOG --title "Tempétarure en temps réel" --gauge "Temps(s)" 20 70 0

    inxi -s > $OUTPUT
    display_output 20 60 "Température après 3 min"
}
