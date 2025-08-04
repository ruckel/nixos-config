#!/usr/bin/env bash

IMG_DIR=$HOME/pictures/
IMG_NAME=bsod.png
#echo $IMG_DIR

#--show-failed-attempts
#--color=663399
#--tiling 
#--ignore-empty-password
#--pointer=win
#--beep
#--image=pictures/bsod.png
#
#i3lock --image=pictures/winXp.png --show-failed-attempts --color=663399 --tiling --ignore-empty-password -b -p win
#i3lock --image=pictures/winXp.png --show-failed-attempts --color=663399 --tiling --ignore-empty-password -b -p win --no-unlock-indicator
#i3lock --image=pictures/bsod.png --tiling --ignore-empty-password --no-unlock-indicator

if [[  $1 == "bsod" ]];then
  # BSOD #
  i3lock --tiling --image=${IMG_DIR}bsod.png --ignore-empty-password --no-unlock-indicator
elif [[ $1 == "transparent" ]];then
  # transparent #
  i3lock --tiling --image=${IMG_DIR}locked.png --ignore-empty-password  --show-failed-attempts --color=663399 --beep
else
  # win XP #
  i3lock --tiling --image=${IMG_DIR}winXp.png --ignore-empty-password -p win --no-unlock-indicator --nofork
fi




