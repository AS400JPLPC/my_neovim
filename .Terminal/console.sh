#!/bin/sh
cd $1
# ecran 32" 3841x2610
exec xfce4-terminal --hide-menubar --hide-scrollbar --hide-toolbar -T "CONSOLE"  --geometry="127x44"  #--font="Source Code Pro 12"
#exec gnome-terminal --hide-menubar   --profile=TUI  --title="CONSOLE"  --geometry="132x32"  -q

exit 0
