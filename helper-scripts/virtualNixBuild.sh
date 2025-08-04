#!/bin/sh
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo $SCRIPT_DIR
 nixos-rebuild build-vm --show-trace --fast --flake ./# --impure \
 -I nixos-config=$SCRIPT_DIR/configuration.nix \
 -I nixpkgs=.
