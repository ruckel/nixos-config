#!/usr/bin/env bash

if [[ $1 == '' ]];then
  echo "missing input"
else
  cp $@{,~}
  echo -e "cp $@ -> $@~"
fi
