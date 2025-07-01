#!/bin/bash

### Vérifier si root

if [[ $EUID -ne 0 ]]
then
	echo "Ce script doit être exécuté en tant que root"

	exit 1

fi

### Si aucun disque n'est fourni

if [[! $1 ]]
then
	echo "Entrez le nom d'un disque"
	echo ""
	echo "Les disques disponibles sont :"
	echo -e "$(ls /dev/sd[a-k])"
	echo ""
	echo "Exemple : /dev/sda"

	exit 1

fi

### Si ce n'est pas un disque

if [[ $1!= "$(ls $1 2> /dev/null)" && $1 =~ /dev/sd* ]]
then
	echo "Ceci n'est pas un disque... Arrêtez ça."
	echo ""

	exit 1

fi

### Si le disque est monté

if [[ $(grep $1 /proc/mounts) ]]
then
	echo ""
	echo "Le périphérique est monté"
	echo ""
	echo "Si ce n'est pas le volume actuellement utilisé (clé USB),"
	echo "démontez le périphérique avant d'écraser"
	echo ""

	exit 1

fi

clear

echo ""
echo ""
echo "============================================================="
echo ""
echo "    Script d'éradication sécurisée ATA automatique"
echo ""
echo "    Inspiré par Maximillian Schmidt"
echo "    OSU UIT, Service Desk"
echo "    Traduit et modifié par Adrien Ferron"
echo "    La Capsule Morlaix"
echo ""
echo "    Version: 1.2.0"
echo ""
echo "    Avertissement : Ce script détruit absolument toutes"
echo "                   les données ! Soyez certain que vous"
echo "                   ne récupererez rien du SSD intégré à cet appareil !"
echo ""
echo "                 VOUS ÊTES PREVENU ! SOYEZ ABSOLUMENT SÛR !"
echo ""
echo "============================================================="
echo ""
echo ""


echo "Le script suppose que $1 est le SSD à détruire"
echo ""
echo "Veuillez vérifier une fois de plus en utilisant le gestionnaire de disques GNOME"
echo "Fermez l'application pour continuer"
printf "(Démarrage dans 5s) "

for i in `seq 1 5`
do
	printf "."
	sleep 1

done

echo ""


gnome-disks


clear


### Confirmer l'éradication

echo "DERNIERE CHANCE"
echo ""

bloweraway="t"

while [[ $bloweraway!= 'y' && $bloweraway!= 'n' && $bloweraway!= 'Y' && $bloweraway!= 'N' ]]
do
	read -n1 -p "Supprimer les données ? (appuyez sur 'y' ou 'n') " bloweraway
	echo ""

done

echo ""

if [[ $bloweraway == 'n' || $bloweraway == 'N' ]]
then
	echo "Revenez quand vous serez prêt !"
	echo ""

	exit 0

fi

### Vérifier si le périphérique est gelé

frozen="$(hdparm -I $1 | grep 'frozen')"

if [[ $frozen!= *"not"* ]]
then
	echo "$1 est gelé!"
	echo ""
	printf "Essayons de mettre en veille dans 3s "

	for i in `seq 1 3`
	do
		printf "."
		sleep 1

	done

	systemctl suspend

	echo "Commande de mise en veille émise..."

	sleep 7

	clear

	echo "Ça a été court, hein..."

fi


### Vérifier si toujours gelé

frozen="$(hdparm -I $1 | grep 'frozen')"

if [[ $frozen!= *"not"* ]]
then
	echo "ERREUR : $1 est toujours gelé !"
	echo ""
	echo "Consultez : https://ata.wiki.kernel.org/index.php/ATA_Secure_Erase"
	echo "pour des options supplémentaires pour dégeler le lecteur"
	
	exit 1

elif [[ $frozen == *"not"* ]]
then
	echo ""
	echo "$1 dégelé"
	echo ""

else
	echo "Breche de coque !"

	exit 1

fi


### Faire le vrai dommage 

if [[ $bloweraway == 'y' || $bloweraway == 'Y' ]]
then
	echo "DEPART DE LA DESTRUCTION - "
	echo ""

	# Définir le mot de passe
	echo "Définition du mot de passe utilisateur..."
	hdparm --user-master u --security-set-pass Blue32 $1
	echo ""

	# Émission de la commande d'éradication sécurisée ATA
	echo "Émission de la commande de déstruction sécurisée ATA..."
	time hdparm --user-master u --security-erase Blue32 $1
	echo ""

fi


### Vérifier que la sécurité a été supprimée, indiquant que le lecteur a été effacé

wiped="$(hdparm -I $1 | grep 'enabled')"

if [[ $wiped == *"not"* ]]
then
	echo ""
	echo "Le lecteur a été correctement détruit !"
	echo "Sortie..."
	echo ""

	exit 0

else
	echo ""
	echo "ERREUR : Le lecteur n'a pas réussi à être détruit !"
	echo "Veuillez vérifier manuellement sur le disque ou le wiki"
	echo ""

	exit 1

fi

exit 2
