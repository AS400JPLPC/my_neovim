#!/bin/sh


# $1 project_lib
# $2 directory



f_cls() {

reset > /dev/null
	echo -en '\033[1;1H'
	echo -en '\033]11;#000000\007'
	echo -en '\033]10;#FFFFFF\007'
}
f_cls

#=========================
# Call Terminal VTE
#=========================

cd $2
nohup  $HOME/.Terminal/TermADW $1 $2 > /dev/null 2>&1 &
exit 0
