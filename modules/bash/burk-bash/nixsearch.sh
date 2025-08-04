#!/usr/bin/env bash

STRICT=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    -s|--strict)
      STRICT=true
      shift
      ;;
    -*)
      echo "Unknown option: $1"
      exit 1
      ;;
    *)
      PKG_TO_SEARCH=$1
      shift
      ;;
  esac
done

if [[ -z $PKG_TO_SEARCH ]]; then
  echo "Usage: nixsearch [-s|--strict] <package name>"
  exit 1
fi


if [[ $STRICT == true ]];then 
  nix search nixpkgs "^${PKG_TO_SEARCH}$"
else 
  nix search nixpkgs "${PKG_TO_SEARCH}"
fi
