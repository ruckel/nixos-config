#!/bin/sh
# Dependencies: xorg-xsetroot
#
loop=true

if [[ $1 == "once" ]]; then
    loop=false
fi

run() {
if [ $loop == 'true' ];then
  echo loop: true
  init
  parallelize .25 & looper .5 &
else
  echo loop: false
  init
  setBar
fi
}

init() {
echo init
# Store the directory the script is running from
LOC=$(readlink -f "$0")
DIR=$(dirname "$LOC")

#export IDENTIFIER="unicode"

#export SEP1="["
#export SEP2="]"
echo importing
# Import the modules
. "$DIR/bar-functions/dwm_networkmanager.sh"
. "$DIR/bar-functions/dwm_date.sh"
#. "$DIR/bar-functions/dwm_spotify.sh"
#. "$DIR/bar-functions/dwm_transmission.sh"
#. "$DIR/bar-functions/dwm_network_speed.sh"
. "$DIR/bar-functions/dwm_battery.sh"
. "$DIR/bar-functions/dwm_vol.sh"

#. "$DIR/bar-functions/dwm_alarm.sh"
#. "$DIR/bar-functions/dwm_alsa.sh"
#. "$DIR/bar-functions/dwm_backlight.sh"
#. "$DIR/bar-functions/dwm_ccurse.sh"
#. "$DIR/bar-functions/dwm_cmus.sh"
#. "$DIR/bar-functions/dwm_connman.sh"
#. "$DIR/bar-functions/dwm_countdown.sh"
#. "$DIR/bar-functions/dwm_currency.sh"
#. "$DIR/bar-functions/dwm_keyboard.sh"
#. "$DIR/bar-functions/dwm_loadavg.sh"
#. "$DIR/bar-functions/dwm_mail.sh"
#. "$DIR/bar-functions/dwm_mpc.sh"
#. "$DIR/bar-functions/dwm_pulse.sh"
#. "$DIR/bar-functions/dwm_resources.sh"
#. "$DIR/bar-functions/dwm_vpn.sh"
#. "$DIR/bar-functions/dwm_weather.sh"
echo init finito
}


parallelize() {
while true; do
  #echo Running parallel processes:
  dwm_networkmanager #&& echo networkmanager
  dwm_date #&& echo date
# dwm_spotify && echo spotify
# dwm_transmission && echo transmission
#  dwm_network_speed && echo networkspeed
  dwm_battery #&& echo battery
  #echo vol && 
  dwm_vol
#  echo with sleep time: $1
  sleep $1
done
}



looper() {
while true; do
  setBar
  sleep $1
done
}

setBar() {
#echo setting bar 
bar="  "

#echo " networkmanager" &&\
 bar="$bar${__DWM_BAR_NETWORKMANAGER__}" 

#echo " vol" &&\
 bar="$bar|$(dwm_vol)"

#echo " battery" &&\
 bar="$bar|$(dwm_battery)" 

#echo " date" &&\
 bar="$bar|" && bar="$bar$(dwm_date)"


xsetroot -name "$bar"
}
run
