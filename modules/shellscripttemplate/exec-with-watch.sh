#!/usr/bin/env bash

#example use:
#./exec-with-watch.sh bash -c 'sudo nixos-rebuild switch --fast --impure --flake ~/nixos-cfg/# && cowsay-scriptus'

if [ -z "$1" ];then
  echo no arg
  exit 1
fi

# if [-x|--execute]; then bash -c '$@'

run=$1
while true; do 
  #watch -g 'ls i-lR --time-style=full-iso' &> /dev/null
  inotifywait -r -e modify,create,delete,attrib . &>/dev/null
  echo -e " $(date +%H:%M.%S)\nchange, e: $*\n"
  #bash -c "$@"
  "$@"
  echo -n '###'
done
