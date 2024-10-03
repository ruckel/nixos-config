#!/bin/sh
nixos-rebuild build-vm --show-trace --fast \
-I nixos-config=./configuration.nix \
-I nixpkgs=.
