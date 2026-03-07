#!/bin/bash

faStabilo='\033[7m'
fcRouge='\033[31m'
fcJaune='\033[33;1m'
fcCyan='\033[36m'
fcGreen='\033[32m'
fcBleu='\033[34m'
fcNoir='\033[0;0m'

faGras='\033[1m'

# lib
projet_lib=$1


# name binary
name_bin=$2

# name worspace
name_wrkspace=$3

# type Compile
mode=""

registry="$HOME/my-registry"
folder_debug=$projet_lib"target/debug"
folder_release=$projet_lib"target/release"
folder_libwrk=$projet_lib"term_lib"
file_cache_lsp="$HOME/.local/state/nvim/lsp.log"


cd $projet_lib

choix=""

=========================
# Func  traitement
#=========================
f_read_RESUTAT() {
    echo -en $faStabilo$fcCyan"BUILD "$mode $fcNoir "  " $fcJaune "main.src" $fcNoir "->" $fcCyan $name_bin $fcNoir
    echo -en "  size : "
    ls -lrtsh "$projet_lib$name_bin" | cut -d " " -f6
    cd $projet_lib
    rm -rf "$projet_lib/target" || true
    rm -rf "$folder_libwrk/target" || true
    echo -en '\033[0;0m'
}
f_clean() {
    rm -f "$registry/$name_wrkspace"*.crate || true
    rm -rf "$projet_lib/target" || true
    rm -rf "$folder_libwrk/target" || true
    rm -rf "$projet_lib$name_bin" || true
    rm -rf "$projet_lib/rustdocs" || true
	if test -f "$file_cache_lsp" ; then
	rm -f $ffile_cache_lsp
	fi
}


#====== TUI

f_error() {
    echo -en '\033[0;0m'
    echo -e $fcRouge"Erreur : $1" $fcNoir
	echo -en '\033[0;0m'
}

f_cls() {

reset > /dev/null
	echo -en '\033[1;1H'
	echo -en '\033]11;#000000\007'
	echo -en '\033]10;#FFFFFF\007'
}


f_pause() {
    echo -en '\033[0;0m'
    echo -en $faStabilo$fcRouge'Press[Enter] key to continue'
    tput civis
    read -s -n 1
    echo -en '\033[0;0m'
}


f_display(){
	echo -en '\033[0;0m'
	echo  -e $1
	echo -en '\033[0;0m'
}

f_dsplyPos() {
    echo -en '\033[0;0m'
    let lig=$1
    let col=$2
    echo -en '\033['$lig';'$col'f'$3$4
}

f_readPos() {
    echo -en '\033[0;0m'
    let lig=$1
    let col=$2
    let colR=$2+${#3}+1
    echo -en '\033['$lig';'$col'f'$fdVert$faGras$fcBlanc$3
    echo -en '\033[0;0m'
    tput cnorm
    echo -en '\033['$lig';'$colR'f'$faGras$fcGreen
    read
    tput civis
    echo -en '\033[0;0m'
}


# resize
printf '\e[8;'24';'120't'

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
while [ "$choix" != "99" ]
do
	cd $projet_lib
    f_cls
    f_dsplyPos 1  24 $faGras$fcJaune 'COMPILE WorkSpace->'$name_wrkspace'  RUST  Bin ->'$name_bin
    f_dsplyPos 2  24 $faGras$fcJaune '----------------------------------------'
    f_dsplyPos 3  20 $faGras$fcRouge' 1.'; f_dsplyPos 3  24 $faGras$fcGreen 'ClearProjet'
    f_dsplyPos 5  20 $faGras$fcRouge' 2.'; f_dsplyPos 5  24 $faGras$fcGreen 'Compile_Debug'
    f_dsplyPos 7  20 $faGras$fcRouge' 3.'; f_dsplyPos 7  24 $faGras$fcGreen 'Compile_Release'
    f_dsplyPos 9  20 $faGras$fcRouge' 4.'; f_dsplyPos 9  24 $faGras$fcGreen 'Compile_Release doc'
    f_dsplyPos 11 20 $faGras$fcRouge'99.'; f_dsplyPos 11 24 $faGras$fcJaune 'Quit'
    f_dsplyPos 11 24 $faGras$fcBleu '----------------------------------------'
    f_readPos  12 20  'Votre choix  :'; choix=$REPLY

    if echo $choix | tr -d [:blank:] | tr -d [:digit:] | grep . &> /dev/null; then
        f_readPos 12 90  'erreur de saisie Enter'
    else
        case "$choix" in
            1)
                echo -e  "Clear Projet_RUST"
                f_clean
                ;;
            2)
                f_cls
                echo -e $faStabilo$fcGreen"Compile_Debug_RUST"$fcNoir
                f_clean
                cd $projet_lib

                cargo build --bin $name_bin --features $name_bin

                if test -f "$folder_debug/$name_bin"; then
                    mode="DEBUG"
                    mv  $folder_debug"/"$name_bin  $projet_lib
                    f_read_RESUTAT
                else
                    f_error "DEBUG Erreur de compilation pour $name_bin"
                fi
                f_pause
            ;;
            3)
                f_cls
                echo -e $faStabilo$fcGreen"Compile_Release_RUST"$fcNoir
                f_clean
                cd $projet_lib


                cargo build --release --bin $name_bin --features $name_bin

                if test -f "$folder_release/$name_bin"; then
                    mode="RELEASE"
                    mv  $folder_release"/"$name_bin  $projet_lib
                    f_read_RESUTAT
                else
                    f_error "RELEASE Erreur de compilation pour $name_bin"
                fi
                f_pause
            ;;

            4)
                f_cls
                echo -e $faStabilo$fcGreen"Compile_Release_Doc_RUST"$fcNoir
                cd $projet_lib
                rm -rf "$projet_lib/rustdocs" || true
                cargo doc --features $name_bin --document-private-items --target-dir "rustdocs"
                f_pause
            ;;
            99)
                break
                ;;
        esac
    fi
done

tput cnorm
exit 0
