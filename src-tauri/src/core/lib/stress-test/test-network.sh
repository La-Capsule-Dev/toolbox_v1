
function testConnexionInternet
{
    # on passe en anglais
    export LANG=en.UTF-8


    DIALOG=${DIALOG=dialog}
    COUNT=0
    (
        while test $COUNT != 100
        do
            echo $COUNT
            echo "XXX"
            echo "Ping en cours"
            echo "XXX"
            COUNT=`expr $COUNT + 25`
        done
    ) |
    $DIALOG --title "Ping en cours" --gauge "Temps(s)" 20 70 0
    testPing=$(ping -c 4  www.google.fr -q | grep packets | cut -d " " -f4 &)

    if (( $testPing == "4" )); then
        answerPing="L'adresse www.google.fr répond avec la commande ping"
        testCurl=$(curl -s -I www.google.fr | grep -o OK)

        if (( testCurl == "OK" )); then
            answerCurl="Le site www.google.fr fonctionne"
            export LANG=fr_FR.UTF-8
            echo "$answerPing\n$answerCurl" > $OUTPUT

            display_output 20 60 "État de la connexion internet"
            DIALOG=${DIALOG=dialog}
            return
        else
            answerCurl="Le site www.google.fr à un problème"
            export LANG=fr_FR.UTF-8
            echo $answerCurl > $OUTPUT
            display_output 20 60 "État de la connexion internet"
            DIALOG=${DIALOG=dialog}
            return
        fi
    else
        answerPing="Problème de connexion réseau"
        export LANG=fr_FR.UTF-8
        echo $answerPing > $OUTPUT
        display_output 20 60 "État de la connexion internet"
        DIALOG=${DIALOG=dialog}
        return
    fi

    # regarde la réponse sur le site internet.

    # on remet en français
    export LANG=fr_FR.UTF-8

    # test informations
    display_output 20 60 "État de la connexion internet"
    DIALOG=${DIALOG=dialog}

}
