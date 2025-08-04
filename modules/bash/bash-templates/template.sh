#!/usr/bin/env bash
: <<'END_COMMENT'
/usr/bin/env because of nixos things
END_COMMENT

script_path="$(readlink -f "$0")"
script_name="$(basename "$script_path")"
script_dir="$(dirname "$script_path")"

function main() {
  echo "main func, $@" 
  parseArgs $@
  if [ ! -z $SHOWHELP ];then cat "${script_path}" && exit 0; fi
  run "arg" "$2" "lol"
}

function parseArgs() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help|-p|--print)
        SHOWHELP=true
        shift
        ;;
      -d|--directory)
        echo "script dir: ${script_dir}"
        shift
        ;; 
      -f|--filename)
        echo  "script file name: ${script_name}"
        shift
        ;;
      -*)
        echo "Unknown option: $1"
        exit 1
        ;;
      *)
        shift
        ;;
    esac
  done
}

function run() {
  echo "another func, $@"
}

main "arg" $@
