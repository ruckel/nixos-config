#!/bin/sh

if [[ $1 == '' ]];then
  echo no port specced
else
  pid="$(lsof -Fp -i :$1)"
  cmd="$(lsof -Fc -i :$1)"

  echo "$1
$cmd"
fi
