#!/bin/sh

run() {
  sum='bogos'
  win='binted :>'
  lose='dorng?! :<'
  panik='vorp! :@'
  
  appName=$sum
  icon='dialog-information-symbolic'
  lvl='normal' #normal,critcal
  cat='farbs'
  sound=/home/korv/Music/notjustfart2.wav
  time='30'
  mpv --no-terminal --keep-open=no --loop-playlist=no  --volume=130 $sound &
  
  body=$1 
  if [[ $1 == '' ]]   ;then body="$lose ~ $@"; fi
  if [[ $1 == '0' ]]  ;then body="$win ~ $@"; fi 
  if [[ $1 == '1' ]]  ;then body="$panik ~ $@" && lvl='critical'; fi
  
  
  
  function toastifysend() {
    toastify send \
    --app-name "$appName" \
    --urgency "$lvl" \
    --icon "$icon" \
    --categories "$cat" \
    --sound-name "$sound" \
    --expire-time "$time" \
    "$sum" "$body" 
  }
  
  function toastifyroot() {
    sudo -u korv DISPLAY=:0 toastify send \
    --app-name "$appName" \
    --urgency "$lvl" \
    --icon "$icon" \
    --categories "$cat" \
    --sound-name "$sound" \
    --expire-time "$time" \
    "$sum" "$body" 
  }
  
  
  if [[ $DESKTOP_SESSION != 'none+dwm' ]];then
    if [[ $USER == "root" ]];then
       toastifyroot
    else
       toastifysend
    fi
  fi
}

run $@

# USAGE:
#     toastify send [OPTIONS] <TITLE> [ARGS]
# 
# ARGS:
#     <TITLE>    Title of the Notification
#     <BODY>     Message body
#     <ID>       Specifies the ID and overrides existing notifications with the same ID
# 
# OPTIONS:
#     -a, --app-name <APP_NAME>          Set a specific app-name manually
#     -c, --categories <CATEGORIES>      Set a category
#     -d, --debug                        Also prints notification to stdout
#     -h, --help                         Print help information
#         --hint <HINT>                  Specifies basic extra data to pass. Valid types are int,
#                                        double, string and byte. Pattern: TYPE:NAME:VALUE
#     -i, --icon <ICON>                  Icon of notification
#     -s, --sound-name <SOUND_NAME>      Set a specific sound manually
#     -t, --expire-time <EXPIRE_TIME>    Time until expiration in milliseconds
#     -u, --urgency <URGENCY>            How urgent is it [possible values: low, normal, critical]
