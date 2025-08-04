#!/bin/sh

checkArgs() {
  if [[ $1 == '-k' || $1 == '--keep' ]];
  then
    RETURN='return'
    PKG=$2
  fi
  
  if [[ $2 == '-k' || $2 == '--keep' ]];then
    RETURN='return'
    PKG=$1
  fi

  if [[ $1 == '-t' || $1 == '--temporary' ]];
  then
    RETURN=''
    PKG=$2
  fi
  if [[ $2 == '-k' || $2 == '--keep' ]];then
    RETURN=''
    PKG=$1
  fi
}

run() {
  RETURN='return'
  PKG=$1
  checkArgs $@  
  nix-shell -p $PKG --command "$PKG; echo -e '${PKG} installed'; $RETURN"
}

if [[ $1 == '' ]];then echo no package specified
else run $@
fi

echo finnish
