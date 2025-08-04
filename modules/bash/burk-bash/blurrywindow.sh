#!/usr/bin/env bash
DCONF_PATH=/org/gnome/shell/extensions/just-perfection/panel
dconf write $DCONF_PATH true
exec photoqt --disable-tray \
$HOME/pictures/wps/empty-bg/trans-bg.png 
pkill -15 photoqt
