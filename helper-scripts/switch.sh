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
    elif [[ $1 == 'switch' ]];then
      PROFILE=$2
      makeSwitch
      exit 0
    fi
  fi
#@${tstamp}
  makeTest
}
makeTest() {
  echo making test round
  sudo -p '' -A -- echo "sudo pw:d"
  sudo nixos-rebuild test  --impure --flake ./#
  #-I nixos-config=$SCRIPT_DIR/configuration.nix #\
  #-I nixpkgs=.
}

makeSwitch() {
  echo $PROFILE
  sudo -p '' -A -- echo "sudo pw:d"
  sudo nixos-rebuild switch --fast --impure --flake ./# \
  --show-trace \
  #-I nixos-config=$SCRIPT_DIR/configuration.nix \
  -p $PROFILE
# -I nixpkgs=.

}

makeBuild() {
  echo "Doing build"
  nixos-rebuild build --fast --impure --flake ./#  \
  -I nixos-config=$SCRIPT_DIR/configuration.nix #\
  #-I nixpkgs=.
}
run $@
