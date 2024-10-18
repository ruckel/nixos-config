#!/bin/sh

# A dwm_bar function to display information regarding system memory, CPU temperature, and storage
# GNU GPLv3

df_check_location='/home'

dwm_vol () {
	cmd=$(wpctl get-volume @DEFAULT_SINK@ | tr . " ")
	vol1=$(echo $cmd | awk '{print $2}' )
	vol2=$(echo $cmd | awk '{print $3}' )
	MUTE=$(echo $cmd | awk '{print $4}' )
	if [[ $vol1 == "0" ]];then vol1=''; fi
	printf "%s" "$SEP1"
	printf "v:%s%s%s" "$vol1" "$vol2" "$MUTE"
	printf "%s\n" "$SEP2"
}

dwm_vol
