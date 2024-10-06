#!/bin/sh
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SCRIPTDIR=/home/${USER}/nixos-config


if [[ $1 != '' ]];then SETPROFILE=$@; else SETPROFILE=''; fi

echo $SETPROFILE
sudo -p '' -A -- echo "sudo pw:d"
sudo nixos-rebuild switch --show-trace --fast\
 #-p '$SETPROFILE'\
 -p 'korv'\
 -I nixos-config=$SCRIPTDIR/configuration.nix\
 -I nixpkgs=. \
> logs/switch.log
# sudo nixos-rebuild switch --show-trace --fast -p 'korv' -I nixos-config=~/nixos-config/configuration.nix -I nixpkgs=. > logs/switch.man.log