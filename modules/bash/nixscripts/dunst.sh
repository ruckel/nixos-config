#!/usr/bin/env bash
fileName=dunst$(date +%y%m%d).log
fileName=dunst.log
calDate=$(date +%y%m%d)
time=$(date +%H:%M)
#appname summary body icon urgency
res="$calDate/$time: $2 - $1
$3
" 

#echo " $2($1)@$time " > dwm/dwm.txt

echo "$res" >> $fileName
echo "$res"

