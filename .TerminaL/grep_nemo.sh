#!/bin/bash

fdBlanc='\033[47;1m'
fcNoir='\033[30m'

f_dsply(){
	echo -en '\033[0;0m'
	echo  -e $1
	echo -en '\033[0;0m'
}

f_read() {
	echo -en '\033[0;0m'
	echo -en $fdBlanc$fcNoir
	read
	echo -en '\033[0;0m'
}
f_clear() {
reset > /dev/null
	echo -en '\033[1;1H'
	echo -en '\033]11;#000000\007'
	echo -en '\033]10;#FFFFFF\007'
}

requete="?"

f_pause(){
    echo -en '\033[0;0m'
     echo -en $faStabilo$fcRouge'Press[Enter] key to continue'
    tput civis     # curseur invisible
    read -s -n 1
    echo -en '\033[0;0m'
}


while [ "$requete" == "?" ]; do
  f_dsply 'veuilez donnez le critère de recherhe:'
  f_read
  requete=$REPLY
  if [  -z $requete  ]; then
    f_dsply 'erreur de saisie';
    read -s -n 1
    f_clear
    requete="?"
  fi


done
requete=$REPLY
grep -B2 --color=auto -rnw $PWD -e $requete 


f_pause
#exit 0
