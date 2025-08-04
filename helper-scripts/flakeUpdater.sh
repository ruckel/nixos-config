#!/usr/bin/env bash
script_path="$(readlink -f "$0")"
script_name="$(basename "$script_path")"
script_dir="$(dirname "$script_path")"
#echo -e "Resolved real path: $script_path"
#echo -e "Resolved real name: $script_name"
#echo -e "Real directory:     $script_dir\n\n"

find ${HOME}/nixos-cfg/ -type f -name 'flake.nix' | \
sed 's/flake.nix//g' | \
xargs -I £ nix flake update -I £/#

nix-collect-garbage -d
