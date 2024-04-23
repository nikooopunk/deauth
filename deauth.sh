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
	echo -e "${yellowColour}[!]${endColour} ${redColour}Este script necesita privilegios${endColour}"
	exit 1
fi

# ctrl+c
function ctrl_c(){
echo -e "\n${redColour}[!]${endColour} ${blueColour}Saliendo...${endColour}\n"
menuPrincipal
}
	
trap ctrl_c INT

#Funciones
function configTargMon(){
	echo -e "${yellowColour}[+]${endColour}${blueColour} Targetas de red disponibles:${endColour}\n"
	echo -e "${blueColour}$(ifconfig | grep 'flags=' | awk '{print "\t", $1}' | tr -d ':' | grep -v lo)\n${endColour}"
	echo -ne "${yellowColour}[+]${endColour}${blueColour} Seleccione una opcion:${endColour} " && read opt2
	echo -e "${yellowColour}[+]${endColour}${blueColour} Configurar targeta a:${endColour}"
	echo -e "${blueColour}\n\tmonitor\n\tmanage\n${endColour}"
	echo -ne "${yellowColour}[+]${endColour}${blueColour} Seleccione una opcion:${endColour} " && read opt3
	if [ $opt3 == "monitor" ];then
		sudo airmon-ng start $opt2
	elif [ $opt3 == "manage" ]; then
		sudo airmon-ng stop $opt2
	else
		echo -e "${redColour}[!]${endColour}${blueColour} Opcion invalida.${endColour}"
		configTargMon
	fi
	if [ $(echo $?) == 0 ]; then
		echo -e "${greenColour}[+]${endColour}${blueColour} Targeta configurada con exito!${endColour}"
		sleep 1
		menuPrincipal
	else
		echo -e "${redColour}[!]${endColour}${blueColour} Ha ocurrido un error.${endColour}"
		sleep 1
		menuPrincipal
	fi
}
function airodump-ng(){
	echo -e "${yellowColour}[i]${endColour}${blueColour} Seleccione targeta de red, recuerde que esta opcion necesita tener una targeta en modo monitor: ${endColour}"
	echo -e "${blueColour}$(ifconfig | grep 'flags=' | awk '{print $1}' | tr -d ':' | grep -v lo | grep 'mon')${endColour}"
	echo -ne "${yellowColour}[+]${endColour}${blueColour} Seleccion: ${endColour}" && read opt4
	echo -ne "${yellowColour}[+]${endColour}${blueColour} Desea guardar el output?(si/no):${endColour} " && read opt8
	if [ $opt8 == "si" ]; then
		echo -ne "${yellowColour}[+]${endColour}${blueColour} Con que nombre desear guardar el output?:${endColour} " && read opt9
		sudo airodump-ng $opt4 --write $opt9
	elif [ $opt8 == "no" ]; then
		sudo airodump-ng $opt4
	else
		echo -e "${redColour}[!]${endColour}${blueColour} Opcion no valida.${endColour}"
		sleep 2
	fi
	if [ $(echo $?) == 0 ]; then
		sleep 1
		menuPrincipal
	else
		echo -e "${redColour}[!]${endColour}${blueColour} Ha ocurrido un error.${endColour}"
		sleep 1
		menuPrincipal
	fi
		
}

function airodump-ng2(){
	echo -e "${yellowColour}[i]${endColour}${blueColour} Seleccione targeta de red, recuerde que esta opcion necesita tener una targeta en modo monitor: ${endColour}"
	echo -e "${blueColour}$(ifconfig | grep 'flags=' | awk '{print $1}' | tr -d ':' | grep -v lo | grep 'mon')${endColour}"
	echo -ne "${yellowColour}[+]${endColour}${blueColour} Seleccion: ${endColour}" && read opt5
	echo -ne "${yellowColour}[+]${endColour}${blueColour} Ingrese el bssid de la red a escanear:${endColour} " && read opt6
	echo -ne "${yellowColour}[+]${endColour}${blueColour} Ingrese el canal de la red a escanear: ${endColour}" && read opt7
	sudo airodump-ng $opt5 --bssid $opt6 --channel $opt7
}

function aireplay(){

	echo -e "${yellowColour}[+]${endColour}${blueColour} Seleccione la targeta de red para el ataque, debe estar en modo monitor:${endColour} "
	echo -e "${blueColour}$(ifconfig | grep 'flags=' | awk '{print $1}' | tr -d ':' | grep -v lo | grep 'mon')${endColour}"
	echo -ne "${yellowColour}[+]${endColour}${blueColour} Seleccion:${endColour} " && read targetaDeAtaque 
	echo -ne "${yellowColour}[+]${endColour}${blueColour} Ingrese el bssid de la red a atacar: ${endColour}" && read bssid
	echo -ne "${yellowColour}[+]${endColour}${blueColour} Ingrese canal de la red a atacar: ${endColour}" && read canal
	sudo iwconfig $targetaDeAtaque channel $canal
	sudo aireplay-ng -0 0 -a $bssid $targetaDeAtaque

}

function showConection(){
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

echo -e "\n${yellowColour}[+]${endColour}${blueColour} Estas conectado a la red:${endColour}${yellowColour} $(nmcli connection show | grep -v '\-\-' | grep -v 'lo' | awk -F '    ' '{print $1}' | tail -n +2)${endColour}"
sleep 3
menuPrincipal
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

echo -e "${yellowColour}[+]${endColour}${blueColour} Menu principal: ${endClour}"
echo -e "\t${yellowColour}[1]${endColour} ${blueColour}Configurar una targeta de red.${endColour}"
echo -e "\t${yellowColour}[2]${endColour}${blueColour} Listar redes wifi disponibles.${endClour}"
echo -e "\t${yellowColour}[3]${endColour}${blueColour} Escanear redes con airodump-ng${endColour}"
echo -e "\t${yellowColour}[4]${endColour}${blueColour} Escanear una red especifica con airodump-ng${endColour}"
echo -e "\t${yellowColour}[5]${endColour}${blueColour} Enviar paquetes de desauntenticacion con aireplay-ng${endColour}"
echo -e "\t${yellowColour}[6]${endColour}${blueColour} Mostrar coneccion actual."
echo -e "\t${yellowColour}[7]${endColour}${blueColour} salir.${endColour}"
echo -ne "${yellowColour}[i]${endColour}${blueColour} Seleccione una opcion: ${endColour}" && read opc1

case $opc1 in
	1) clear; configTargMon;;
	2) gnome-terminal -- bash -c "nmcli device wifi list";menuPrincipal ;;
	3) airodump-ng;;
	4) airodump-ng2;;
	5) aireplay;;
	6) showConection;;
	7) exit 0;;
esac

}

menuPrincipal
