#!/bin/sh
# Check the disk's S.M.A.R.T. (Self-Monitoring, Analysis, and Reporting Technology)

DEV=sda
#sudo smartctl -a /dev/$DEV

# --health --info --capabilities --xall --scan --test [short|long]
TORUN=sudo -A smartctl --test short --xall /dev/$DEV
nix-shell -p smartmontools --command=$TORUN
