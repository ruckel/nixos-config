#!/usr/bin/env bash
TIMESTAMP=$(date +%F_%H%M)
echo $TIMESTAMP
sudo nixos-rebuild switch --fast --impure --flake ~/nixos-cfg/# -p $TIMESTAMP

