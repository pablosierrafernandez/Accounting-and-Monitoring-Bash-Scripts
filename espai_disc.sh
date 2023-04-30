#!/bin/bash
# AUTOR: PABLO SIERRA VERSION: 1.0
#--------------------------------------------
# espai_disc.sh 
#--------------------------------------------
#############################################
# Script para ver cuanto espacio de disco 
# ocupan los directorios de entrada de los 
# usuarios que estan bajo el directorio 
# /home y que han entrado en los últimos 
# 3 días.
#############################################


green="\e[32m"
red="\e[31m"
fin_color="\033[0m"


# AYUDA

Help()
{
echo -e "MODO DE EMPLEO: ${green}espai_disc.sh${fin_color}"
echo -e "FUNCIÓN:# Script para ver cuanto espacio de disco ocupan los directorios de entrada de los  usuarios que estan bajo el directorio /home y que han entrado en los últimos 3 días."
echo -e "OPCIONES: NONE"
echo -e "PARÁMETROS: NONE"
echo -e "CONDICIONES:${green}Ejecutar como root${fin_color}"

}
while getopts ":h" option; do
	case $option in
		h)Help
		exit 1;;
	esac
done

##SI NO SE ES ROOT SALIR

if [ "$EUID" -ne 0 ]
then
	echo -e "${red}Por favor, ejecute como ROOT${fin_color}" >&2
	exit 1
  Help
  exit
fi

##EMPIEZA EL PROGRAMA
msn=""

##CON LA COMANDA 'LAST' PODEMOS VER LOS USUARIOS CONECTADOS EN LOS ULTIMOS X DIAS
all_logins=`last --since -3days | awk '{print $1}' | sort | uniq`

##PARA TODOS LOS USUARIOS DEL DIRECTORIO /HOME QUE HAYAN SIDO CONECTADOS
for user in $all_logins
do
  if [ -d /home/$user ]
  then
    msn=`echo -e "$msn\n  [USER] $user:"; du -s /home/$user | awk '{print $1" Bytes"}'; du -sh /home/$user | awk '{print $1 "\n" }'`
  fi

done

##MOSTRAMOS CON VENTANA

xmessage -buttons Okey:0 -default Okey -buttons ok:0 -default ok -nearmouse "$msn" -fg black -bg white -title "ESPACIO DISCO" -geometry 250

exit 0
