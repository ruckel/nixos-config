#!/usr/bin/env bash 

pkill thunar
#echo "running: env GTK_THEME=Adwaita:dark thunar --daemon"
env GTK_THEME=Adwaita:dark thunar --daemon &

sleep .1
env GTK_THEME=Adwaita:dark thunar

