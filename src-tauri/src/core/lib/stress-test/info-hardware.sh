
function infoSysteme(){
    hardinfo
}

#
# test l'écran
# HACK: A tester
# function testMoniteur(){
#     screentest
# }

#
# Relevé Ram
#
function releveRAM(){
    sudo inxi -m > $OUTPUT
    display_output 20 60 "Relevé RAM"
}

#
# Relevé CPU
#
function releveCPU(){
    sudo inxi -C > $OUTPUT
    display_output 20 60 "Relevé CPU"
}

#
# Relevé batterie
#
function releveBatterie(){
    sudo acpi -i > $OUTPUT
    display_output 20 60 "Relevé batterie"
}

#
# Relevé réseau
#
function releveReseau(){
    sudo inxi -N > $OUTPUT
    display_output 20 60 "Relevé réseau"
}

#
# Santé disque
#
function santeDisque(){
    autoMenuDisque
    sudo skdump --overall /dev/$CHOICE > $OUTPUT
    display_output 20 60 "Santé disque"
}

#
# Info disque
#
function infoDisque(){
    autoMenuDisque
    sudo smartctl -i /dev/$CHOICE > $OUTPUT
    display_output 20 60 "Santé disque"
}

#
# Info GPU
#
function infoGPU(){
    sudo inxi -G > $OUTPUT
    display_output 20 60 "info GPU"
}
