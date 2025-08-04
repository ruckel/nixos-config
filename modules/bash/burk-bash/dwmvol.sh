#!/usr/bin/env bash

getVol=$(wpctl get-volume @DEFAULT_SINK@)

vol=$(wpctl get-volume @DEFAULT_SINK@ | tr -d . | cut -d " " -f 2)
dec=$(wpctl get-volume @DEFAULT_SINK@ | cut -d . -f 2)
muted=$(wpctl get-volume @DEFAULT_SINK@ | cut -d " " -f 3)
echo "Volume: 0.60" | cut -d " " -f 2,3


echo getVol: $getVol 
echo vol: $vol 
echo muted: $muted
