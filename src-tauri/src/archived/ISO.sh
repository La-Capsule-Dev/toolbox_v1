#!/usr/bin/env bash

set -euo pipefail

source "$CORE_DIR/etc/config/path.env"
source "$LIB_DIR/pkgmgr/wrapper.sh"
source "$LIB_DIR/ui/echo_status.sh"

# NOTE: Archivé -> Car pinguins ne supporte pas toutes les distrib Linux
# Mais à voir d'un pour objectif pédagogique
product_iso(){
    echo_status "Vérification des updates du système"
    sudo apt update && echo_status_ok "Update réussi" || echo_status_error "Update non réussi"
    echo_status "Installation du paquet Penguin's EGG "

    echo_status "Vérification des prérequis "
    PKG_OK=$(dpkg -s eggs | grep "Eggs est bien présent")

    if [ "" = "$PKG_OK" ]; then
        # TODO: Modifier le curl pour ne pas défendre de node ou le laisser ainsi
        echo_status_warn "Penguin's EGG n'est pas installé, installation en cours..."
        curl -fsSL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh || echo_status_error "Curl n'a pas trouve la source du download"

        echo_status_ok "Installation réussi"
        sudo -E bash nodesource_setup.sh || echo_status_error "Erreur de lancement"
        sudo dpkg -i penguins-eggs-10.0.5-1_amd64.deb
    fi

    sudo apt install -f && echo_status_ok "Installation réussie"
    echo_status "Début de production de l'ISO "
    $EDITOR bash -c 'sudo eggs produce --clone' && echo_status_ok "Production de l'iso réussi" || echo_status_error "Échec de la production de l'iso"
    echo_status_ok "Ouverture..."
}

product_iso


delete_eggs(){
    # ❌ Correction : dpkg -r ne prend pas un .deb, mais un nom de paquet
    # Si tu veux supprimer le paquet installé par ce .deb, tu dois en extraire le nom
    # Exemple : sudo dpkg -r eggs
    # Tu peux automatiser cela avec dpkg -I :
    #   pkg_name=$(dpkg-deb -f MULTITOOL/eggs_9.6.8_amd64.deb Package)

    if [[ -f "MULTITOOL/eggs_9.6.8_amd64.deb" ]]; then
        pkg_name=$(dpkg-deb -f MULTITOOL/eggs_9.6.8_amd64.deb Package)
        echo_status "Suppression du paquet installé depuis eggs_9.6.8"
        sudo dpkg -r "$pkg_name" && echo_status_ok || echo_status_error "Échec suppression $pkg_name"
    else
        echo_status_error "Fichier MULTITOOL/eggs_9.6.8_amd64.deb introuvable"
    fi
}
