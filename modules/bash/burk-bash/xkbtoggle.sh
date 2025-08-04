#!/usr/bin/env bash
xkbQuery=$(setxkbmap -query | grep dvorak | tr -s ' ' | cut -d " " -f 2)

if [[ $xkbQuery == 'dvorak'  ]]; then
  echo setting se qwerty
  setxkbmap se
else
  echo setting se dvorak
  setxkbmap se dvorak
fi
