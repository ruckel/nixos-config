#!/bin/sh
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SCRIPTDIR=/home/${USER}/nixos-cfg
name=korvus
tstamp=$(date +%y%m%d-%H:%M)

run() {
  if [[ $1 != '' ]];then
    if [[ $1 == 'build' ]];then
      makeBuild
      exit 0
    else
      name=$1
    fi
  fi
  PROFILE=${name}
#@${tstamp}
  makeSwitch
}

makeSwitch() {
  echo $PROFILE
  #printf "sudo pw: "
  #read -s PW
  #echo $PW |
  sudo -p '' -A -- echo "sudo pw:d"
  sudo nixos-rebuild switch --show-trace --fast \
  -I nixos-config=$SCRIPT_DIR/configuration.nix \
  -I nixpkgs=. \
  -p $PROFILE
}

makeBuild() {
  echo "Doing build"
  nixos-rebuild build --show-trace --fast \
  -I nixos-config=$SCRIPT_DIR/configuration.nix \
  -I nixpkgs=.
}
run $@
