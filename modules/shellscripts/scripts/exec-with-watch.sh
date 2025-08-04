#!/usr/bin/env bash

#example use:
EXAMPLE="exec-with-watch bash -c 'sudo nixos-rebuild switch --fast --impure --flake ~/nixos-cfg/# && cowsay-scriptus'"

if [ -z "$1" ];then
  echo "usage: ${EXAMPLE}"
  echo "or: exec-with-bash lol"
  exit 1
fi

# if [-x|--execute]; then bash -c '$@'

run=$1
while true; do 
  #watch -g 'ls i-lR --time-style=full-iso' &> /dev/null
  #listenForFileChange=$(inotifywait -r -e modify,create,delete,attrib . &>/dev/null)
  changed_file=$(inotifywait -r -e modify,create,delete,attrib --format '%w%f' . 2>/dev/null)

  if [[ "$changed_file" == *.swp ]]; then continue; fi
  echo -e " $(date +%H:%M.%S)\n\`$changed_file\` changed, running: \`$*\`\n"

  "$@"
  #bash -c "$@"
  #if [ !$1 == 'lol' ]; then "$@" ;else echo lol; fi

  echo -n '###'
done
