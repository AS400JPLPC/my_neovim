#!/bin/bash

if [ "$1" -eq 1 ] ; then

	exec xfce4-terminal --hide-menubar  --title="Compile-C/CC"  -x  $HOME/.Terminal/EnvCPP.sh $2 $3

fi



if [ "$1" -eq 5 ] ; then

	exec xfce4-terminal --hide-menubar  --title="Compile-wrk-Rust-bin"   -x  $HOME/.Terminal/EnvRust.sh $2 $3 $4

fi




if [ "$1" -eq 30 ] ; then

	xfce4-terminal --hide-menubar  --title="Edit-Source"   -x  $HOME/.Terminal/editing.sh $2

fi



exit 0
