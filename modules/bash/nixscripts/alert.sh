#!/bin/sh

sum='terbinal'
body='korv bröt'

if [[ $1 != '' ]];then
  body=$1
fi

body="$body ($?)"

mpv --no-terminal --keep-open=no --loop-playlist=no  --volume=110 /home/korv/nc/audio/Notifications/biong.mp3 &

appName=$sum
icon=''
lvl='normal'
cat=''
sound='/home/korv/nc/audio/Notifications/vittu.wav'
time='30'

function toastifyF() {
  toastify send \
  --app-name "$appName" \
  --urgency "$lvl" \
  --icon "$icon" \
  --categories "$cat" \
  --sound-name "$sound" \
  --expire-time "$time" \
  "$sum" "$body"
}

function toastifyAsroot() {
  sudo -u korv DISPLAY=:0 toastify send \
  --app-name "$appName" \
  --urgency "$lvl" \
  --icon "$icon" \
  --categories "$cat" \
  --sound-name "$sound" \
  --expire-time "$time" \
  "$sum" "$body"
}

if [[ $USER == "root" ]];then
  toastifyAsroot
else
  toastifyF
fi

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
