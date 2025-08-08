#!/usr/bin/env bash
: <<'END_COMMENT'
/usr/bin/env because of nixos things
END_COMMENT

version=$(nixos-version | cut -d '.' -f 1,2 | tr -d .)

SUDO="sudo -A "
basecommand="nixos-rebuild switch --flake ${HOME}/nixos-cfg/# --impure"
no_reexec=" --no-reexec"



function parseArgs() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        SHOWHELP=true
        shift
        ;;
      -p|--profile)
        profile=" --profile $2"
        shift 2
        ;;
      -d|--debug)
        debug="true"
        shift 1
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
parseArgs $@

if [[ $version < 2505 ]];then no_reexec=" --fast";fi
#if [[ $HOSTNAME != "nixburk" ]];then Alert='';fi


echo "nixos $version"
final_cmd="${SUDO}${basecommand}${no_reexec}${profile}"

if [ -n "$debug" ]; then echo "cmd: $final_cmd" && exit; fi
${final_cmd}
alert $?
