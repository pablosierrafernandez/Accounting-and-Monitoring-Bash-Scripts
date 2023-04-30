#!/bin/bash
# AUTOR: PABLO SIERRA VERSION: 1.0
#--------------------------------------------
# test_estres.sh 
#--------------------------------------------
#############################################
# Script para monitorear la memoria, cpy y 
# disco durante un test de estres.
#############################################


green="\e[32m"
red="\e[31m"
fin_color="\033[0m"


# AYUDA

Help()
{
echo -e "MODO DE EMPLEO: ${green}test_estres.sh${fin_color}"
echo -e "FUNCIÓN: Script para monitorear la memoria, cpy y disco durante un test de estres."
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

## SI NO SE ES ROOT SALIR

if [ "$EUID" -ne 0 ]
then
	echo -e "${red}Por favor, ejecute como ROOT${fin_color}" >&2
	exit 1
  Help
  exit
fi
## Comprobar si existe el paquete
dpkg -l sysstat &> /dev/null
if [ $? -ne 0 ]
then
echo "${green}Instalando paquetes..."
apt-get install sysstat
echo "${green}INSTALADO!"
fi

## Abrimos en una nueva terminal el 'tload' para ver graficamente el estres
xterm -e tload -d 1 &

## Dormimos 5 segundos para ver el cambio más drasticamente
sleep 5

## Ejecutamos las comandas de estres e imprimimos los resultados en un fichero para ver el reporte
## Filtramos minimamente la informacion para ver de manera mas clara los datos

echo "======================================" > test.txt
echo "		Test de estres" >> test.txt
echo "======================================" >> test.txt
echo "ACTUAL" >> test.txt
uptime >> test.txt
echo "====TEST DE <CPU>====" >> test.txt
echo "·······VMSTAT·······" >> test.txt
stress --cpu 4 -t 10s & >> /dev/null
vmstat -an 1 5 | tail -n +3 | awk {'print $13 " %CPU"'} >> test.txt
echo "······IOSTAT······" >> test.txt
stress --cpu 4 -t 10s & >> /dev/null
iostat -c 1 5 | tail -n +3 | tr -s '\n' | grep -v -e "avg-cpu" | awk {'print $1" %CPU"'} >> test.txt

echo "====TEST DE <RAM>====" >> test.txt
echo "······VMSTAT······" >> test.txt
stress --vm 6 -t 10s & >> /dev/null
vmstat -an 1 5 | tail -n +3 >> test.txt


echo "====TEST DE <DISCO>====" >> test.txt
echo "······VMSTAT······" >> test.txt
stress --hdd 2 --io 4 --vm 6 -t 10s & >> /dev/null
vmstat -dn 1 5 | tail -n +3 >> test.txt
echo "······IOSTAT······" >> test.txt
stress --hdd 2 --io 4 --vm 6 -t 10s & >> /dev/null
iostat -d 1 5 | tail -n +3 >> test.txt
echo "FINAL" >> test.txt
uptime >> test.txt
sleep 10
echo -e "${green}Programa de estrés acabado.\nCierre las ventanas para finalizar.\033[0m"

## Abrimos el fichero con el reporte
xterm -e vi test.txt
exit 0
