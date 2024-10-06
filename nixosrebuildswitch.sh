#!/bin/sh
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo $SCRIPT_DIR
 sudo nixos-rebuild switch --show-trace --fast \
 -I nixos-config=$SCRIPT_DIR/configuration.nix \
 -I nixpkgs=.
