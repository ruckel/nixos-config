#!/usr/bin/env bash
setVol() {
  vol=$(wpctl get-volume @DEFAULT_SINK@ | tr -d . | cut -d " " -f 2,3)
}

setTime() {
  if [[ $1 == '' ]]; then time=$(date "+%H %M")
  else time=$(date "+%H:%M")
  fi
}
setRoot() {
  xsetroot -name "  v:$vol% | $time  "
}
setVol 
setTime :
xsetroot -name " korv "
sleep .2
echo vol:${vol} time:${time}
while true; do
    sleep .25
    setVol 
    setTime
    setRoot
    sleep .25
    setVol 
    setRoot
    sleep .25
    setVol
    setRoot
    sleep .25 #1s
    setVol 
    setRoot
    sleep .25
    setVol 
    setTime :
    setRoot
    sleep .25
    setVol 
    setRoot
    sleep .25
    setVol
    setRoot
    sleep .25 #2s
    setVol 
    setRoot
done
