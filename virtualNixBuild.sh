#!/bin/sh
nixos-rebuild build-vm --fast \
-I nixos-config=./configuration.nix \
-I nixpkgs=.
