#!/usr/bin/env bash
IMG_DIR=$HOME/Pictures/
IMG_NAME=locked.png

: <<'END_COMMENT'
  i3lock args:
  --show-failed-attempts
  --color=663399
  --tiling 
  --ignore-empty-password
  --pointer=win
  --beep
  --image=pictures/bsod.png
  --no-unlock-indicator
END_COMMENT
#i3lock --image $HOME/files/pictures/locked.png --tiling

function main() {
  parseArgs $@
}
function parseArgs() {
  if [ -z $1 ]; then def; fi
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        showHelp
        exit
        ;;
      -b|--bliss)
        bliss
        exit
        ;;
      -d|--bsod)
        bsod
        exit
        ;;
      -t|--transparent)
        transparent
        exit
        ;;
      -x|--xp)
        xp
        exit
        ;;
      -*)
        echo "Unknown option: $1"
        showHelp
        exit 1
        ;;
      *)
        shift
        ;;
     esac
   done
}
function showHelp() {
  echo -n "i3lock.sh
  Usage: i3lock [args]

  Args:
  -h --help         Show this help and exit
  -b --bsod         Blue screen of death
  -t --transparent  Minimal
  -x --xp           Fake Windows
  "
}
function checkImgPath() {
  if [ ! -f $1 ];then 
    echo "img path (${1}) empty"
    sleep 2
    def
    exit 1
  fi
}
function def() {
  i3lock \
  --ignore-empty-password \
  --show-failed-attempts \
  --color=000000
}
function bliss() {
  img_path="${IMG_DIR}wps/bliss.png"
  checkImgPath $img_path &&\
  i3lock \
    --image=${img_path} \
    \--tiling \
    --ignore-empty-password \
    --show-failed-attempts \
    --beep
}
function deathScreen() {
  img_path="${IMG_DIR}bsod.png"
  checkImgPath $img_path &&\
  i3lock \
    --image=${img_path} \
    --tiling \
    --ignore-empty-password \
    --no-unlock-indicator
}
function transparent() {
  img_path="${IMG_DIR}locked.png"
  checkImgPath $img_path &&\
  i3lock \
    --image=${img_path} \
    --tiling \
    --ignore-empty-password \
    --show-failed-attempts \
    --color=663399 \
    --beep
}
function xp() {
  img_path="${IMG_DIR}winXp.png"
  checkImgPath $img_path &&\
  i3lock \
    --image=${img_path} \
    --tiling \
    --ignore-empty-password \
    -p win \
    --no-unlock-indicator \
    --nofork
}

main $@

: <<'END_COMMENT'
  i3lock --image=pictures/winXp.png --show-failed-attempts --color=663399 --tiling --ignore-empty-password -b -p win
  i3lock --image=pictures/winXp.png --show-failed-attempts --color=663399 --tiling --ignore-empty-password -b -p win --no-unlock-indicator
  i3lock --image=pictures/bsod.png --tiling --ignore-empty-password --no-unlock-indicator
END_COMMENT

