#!/usr/bin/env bash

parseArgs () {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -k|--keep)
        keep=tru
        shift ;;
      -t|--temporary)
        keep=''
        shift ;;
      -*)
        echo "Unknown option: $1"
        exit 1;;
      *)
        cmd+="$1"
        shift;;
     esac
   done
}
run () {
  parseArgs "$@"
  [[ -z "${cmd}" ]] && echo no package specified && exit 2
  [[ -z "${keep}" ]] && RETURN='exit $?' || RETURN='return'
  echo "$cmd"
  nix-shell -p "$cmd" --command "$cmd; echo -e '${cmd} installed'; $RETURN"
}
run "$@"
echo finnish
