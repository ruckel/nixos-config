#!/bin/sh

cat ~/scripts/nix/storeresult.txt | grep nixos.gnomeExtensions \
| grep "$1" \
| grep "$2" \
| grep "$3" \
| grep "$4" \
| grep "$5" \
| grep "$6" \
| grep "$7" \
| grep "$8" \
| grep "$9"
