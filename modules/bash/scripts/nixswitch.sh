#!/usr/bin/env bash
: <<'END_COMMENT'
/usr/bin/env because of nixos things
END_COMMENT

version=$(nixos-version | cut -d '.' -f 1,2 | tr -d .)

basecommand="nixos-rebuild switch --flake ${HOME}/nixos-cfg/# --impure"
no_reexec=" --no-reexec"
SUDO="sudo -A "
Alert="${HOME}/scripts/alert"
if [[ $version < 2505 ]];then no_reexec=" --fast";fi
if [[ $HOSTNAME != "nixburk" ]];then Alert='';fi
final_cmd="${SUDO}${basecommand}${no_reexec}"

echo "nixos $version"
${final_cmd}
$Alert $?
