#!/usr/bin/env bash

# Script de maintenance faire pendant le stge à goupil.
# Fait RUFFENACH Timothée
# Le 02/06/2022
# Version 1

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
		echo $(cat $data) | sudo -S -s ls >/dev/null;;
  	1)
    	echo "Bye";;
  	255)
    	echo "Touche ESC appuyée." 
	esac
}

function display_output(){
	local h=${1-10}			# box height default 10
	local w=${2-41} 		# box width default 41
	local t=${3-Output} 	# box title 
	dialog --backtitle "Linux Shell Script Tutorial" --title "${t}" --clear --msgbox "$(<$OUTPUT)" ${h} ${w}
}
#
# Automatique menu pour le choix des disque
#

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

#
# Affiche les informations systèmes
#
function infoSysteme(){
	hardinfo
}

#
# test l'écran
#
function testMoniteur(){
	screentest
}

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

#
# stress CPU
#
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

#
# test USB 
#
function testUSB()
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
		testUSB
	else
		return
	fi

}

#
# test Son 
#

function testSon
{
	mplayer /usr/share/LACAPSULE/MULTITOOL/Test/test.wav > /dev/null 2>&1 &
	echo "Test du son" > $OUTPUT
   display_output 20 60 "Message"
}

#
# test Micro
#

function testMicro
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

#
# Test la WebCam
#

function testWebCam
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

#
# Test du clavier
#

function testClavier
{
	x-www-browser https://www.test-clavier.fr/
}

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

#
# Fait une mise du système
#

function majSysteme
{
	DIALOG=${DIALOG=dialog}
	COUNT=0
	(
	while test $COUNT != 100
	do

		cat <<EOF
XXX 
$COUNT
Mise à jour de la liste des paquets existant
XXX
EOF
	sudo apt update -y >/dev/null 2>&1  
	(( COUNT+=25 ))

	cat <<EOF
XXX 
$COUNT
Mise à jour des logiciels
XXX
EOF

	sudo apt upgrade -y >/dev/null 2>&1  
	(( COUNT+=25 ))

	cat <<EOF
XXX 
$COUNT
Suppression des logiciels non nécessaire 
XXX
EOF

	sudo apt autoremove -y >/dev/null 2>&1  

	(( COUNT+=25 ))
	
	cat <<EOF	
XXX 
$COUNT
Suppression du cache logiciel
XXX
EOF
	sudo apt autoclean -y >/dev/null 2>&1  
	(( COUNT+=25 ))
	done
	) |
	$DIALOG --title "Mise à Jour du système" --gauge "Temps(s)" 20 70 0	
}

#
# Installation des bon logiciels pour le scripte fonctionne
#

function installLogiciel
{
	DIALOG=${DIALOG=dialog}
	COUNT=0
	(
	while test $COUNT != 100
	do
######1
		cat <<EOF
XXX 
$COUNT
Installation de hardinfo
XXX
EOF
	sudo apt install hardinfo -y >/dev/null 2>&1  
	(( COUNT+=8 ))
######2
		cat <<EOF
XXX 
$COUNT
Installation de stress-ng
XXX
EOF
	sudo apt install stress-ng -y >/dev/null 2>&1  
	(( COUNT+=8 ))
######3
		cat <<EOF
XXX 
$COUNT
Installation de screentest
XXX
EOF
	sudo apt install screentest -y >/dev/null 2>&1  
	(( COUNT+=8 ))
######4
		cat <<EOF
XXX 
$COUNT
Installation d'inxi
XXX
EOF
	sudo apt install inxi -y >/dev/null 2>&1  
	(( COUNT+=8 ))
######5
		cat <<EOF
XXX 
$COUNT
Installation d'acpi
XXX
EOF
	sudo apt install acpi -y >/dev/null 2>&1  
	(( COUNT+=8 ))
######6
		cat <<EOF
XXX 
$COUNT
Installation de libatasmart-bin
XXX
EOF
	sudo apt install libatasmart-bin -y >/dev/null 2>&1  
	(( COUNT+=8 ))
######7
		cat <<EOF
XXX 
$COUNT
Installation de smartmontools
XXX
EOF
	sudo apt install smartmontools -y >/dev/null 2>&1  
	(( COUNT+=8 ))
######8
		cat <<EOF
XXX 
$COUNT
Installation de mplayer
XXX
EOF
	sudo apt install mlayer -y >/dev/null 2>&1  
	(( COUNT+=8 ))
######9
		cat <<EOF
XXX 
$COUNT
Installation d'alsautils
XXX
EOF
	sudo apt install alsautils -y >/dev/null 2>&1  
	(( COUNT+=8 ))
######10
		cat <<EOF
XXX 
$COUNT
Installation de cheese
XXX
EOF
	sudo apt install cheese -y >/dev/null 2>&1  
	(( COUNT+=8 ))
######11
		cat <<EOF
XXX 
$COUNT
Installation d'x-www-browser
XXX
EOF
	sudo apt install x-www-brower -y >/dev/null 2>&1  
	(( COUNT+=8 ))
######12
		cat <<EOF
XXX 
$COUNT
Installation de curl
XXX
EOF
	sudo apt install curl -y >/dev/null 2>&1  
	(( COUNT+=12 ))

	done
	) |
	$DIALOG --title "Installation des logiciels" --gauge "Temps(s)" 20 70 0
}


function main {
	# utilitymenu.sh - A sample shell script to display menus on screen
	# Store menu options selected by the user
	INPUT=/tmp/menu.sh.$$

	# Storage file for displaying cal and date command output
	OUTPUT=/tmp/output.sh.$$

	# trap and delete temp files
	trap "rm $OUTPUT; rm $INPUT; exit" SIGHUP SIGINT SIGTERM

	#
	# Purpose - display output using msgbox 
	#  $1 -> set msgbox height
	#  $2 -> set msgbox width
	#  $3 -> set msgbox title
	#

	# mettre le clavier en français
	setxkbmap fr

	# activation des droits administrateur
	sudo_activate

	#
	# set infinite loop
	#

	while true
	do

	### display main menu ###
	dialog --clear  --help-button --backtitle "Maintenance" \
	--title "Menu principal" \
	--menu "Vous pouvez utiliser les touches Haut ou Bas, la première \n\
	afficher en subrillance , ou les \n\
	nombre du clavier pour faire votre choix.\n\
	Choose the TASK" 80 80 80 \
	Information_système_en_graphique "" \
	Test_du_moniteur "" \
	Relevé_RAM "" \
	Relevé_CPU "" \
	Relevé_batterie "" \
	Relevé_réseau "" \
	Santé_disque "" \
	Infos_disque "" \
	Infos_carte_graphique "" \
	Stress_test_du_CPU "" \
	Test_des_ports_USB "" \
	Test_son "" \
	Test_micro "" \
	Test_webCam "" \
	Test_Clavier "" \
	Test_Connexion_internet "" \
	Ré_installer_les_logiciels "" \
	MAJ_du_système "" \
	Quit "" 2>"${INPUT}"

	menuitem=$(<"${INPUT}")


	# make decsion 
	case $menuitem in
		Information_système_en_graphique ) infoSysteme;;
		Test_du_moniteur ) testMoniteur;;
		Relevé_RAM ) releveRAM;;
		Relevé_CPU ) releveCPU;;
		Relevé_batterie ) releveBatterie;;
		Relevé_réseau ) releveReseau;;
		Santé_disque ) santeDisque;;
		Infos_disque ) infoDisque;;
		Infos_carte_graphique ) infoGPU;;
		Stress_test_du_CPU ) stressCPU;;
		Test_des_ports_USB) testUSB;;
		Test_son ) testSon;;
		Test_micro ) testMicro;;
		Test_webCam ) testWebCam;;
		Test_Clavier ) testClavier;;
		Test_Connexion_internet) testConnexionInternet;;
		Ré_installer_les_logiciels ) installLogiciel ;;
		MAJ_du_système ) majSysteme ;;
		Quit) echo "Bye"; break;;
	esac

	done

	# if temp files found, delete em
	[ -f $OUTPUT ] && rm $OUTPUT
	[ -f $INPUT ] && rm $INPUT
}

main
