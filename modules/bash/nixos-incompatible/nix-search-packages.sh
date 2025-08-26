#!/usr/bin/env bash

gethelp () {
  echo "nix-search-packages"
  echo "Just my own tool for 'nix search pkgs'"
  echo "  "
  echo "Usage: nix-search-packages [-h] [-s|--strict] [-a|--all] <package name[s]>"
  #echo "  "
  #echo "  "
  #echo "  "
  exit $1
}
tosearch=()
while [[ $# -gt 0 ]]; do case "$1" in
  -s|--strict)
    strict=ye
    shift ;;
  -a|--all)
    all=ye
    echo "Matching all packages"
    shift ;;
  -*)
    [[ "$1" == "-h" ]] && gethelp
    echo "Unknown option: $1" 
    gethelp 1 ;;
  *)
    tosearch+=("$1")
    shift ;;
esac done

if [[ -n "$all" ]];then nix search nixpkgs ^ ; exit $? ; fi

[[ ${#tosearch[@]} -lt 1 ]] && echo -e "\e[31merror:\e[0m no package names provided" && exit 418

for p in ${tosearch[@]}; do 
  [[ -z "$strict" ]] \
    && nix search nixpkgs  "${p}" \
    || nix search nixpkgs "^${p}$" | grep --color=always --context=3 -i "${p}"
done
