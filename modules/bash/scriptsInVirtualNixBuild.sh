#!/bin/sh
nixos-rebuild build-vm --fast \
-I nixos-config=./configuration.nix \
-I nixpkgs=. \
-E 'with import <nixpkgs> { }; callPackage nixscripts/helloworld.nix { }'
