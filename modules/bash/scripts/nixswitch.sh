#!/usr/bin/env bash
: <<'END_COMMENT'
/usr/bin/env because of nixos things

nixos-version: command not found
cut: command not found
tr: command not found
sudo: command not found
alert: command not found
END_COMMENT

#version=$(nixos-version | cut -d '.' -f 1,2 | tr -d .)
version=$(cat /etc/os-release | grep VERSION_ID | cut -d '"' -f 2 | tr -d .)

#SUDO="sudo -A "
basecommand="nixos-rebuild switch --flake ${HOME}/nixos-cfg/# --impure"
no_reexec=" --no-reexec"


deps=(mpv nixos-version cut tr mmpv)
: <<'END_COMMENT'
  /usr/bin/env because of nixos things
  
  nixos-version: command not found
  cut: command not found
  tr: command not found
  sudo: command not found
  alert: command not found
END_COMMENT

vol_def=80
sound_def=${HOME}/music/windows3-1startup.mp3  #notjustfart2.wav
bad_sound_def=${HOME}/Music/bwomp.mp3

main () {
  parseArgs $@
  tmpout=$(mktemp -t XXXX) && tmperr=$(mktemp -t XXXX)
  setOpts
  run
  xCode=$?
  [[ -n "$debug" ]] && echo stdout: && cat $tmpout && echo stderr && cat $tmperr
  alert $xCode &
  rm $tmpout $tmperr
  exit $xCode
}
parseArgs() {
  while [[ $# -gt 0 ]]; do case "$1" in
    -h|--help) showHelp 0 ;;
    -p|--profile)
      profile=" --profile-name $2"
      shift 2 ;;
    -d|--debug)
      debug=tru
      shift ;;
    -t|--trace)
      show_trace=" --show-trace"
      shift ;;
    -v|--volume)
      vol="$2"
      shift 2 ;;
    -S|--sound)
      sound="$2"
      shift 2 ;;
    -E|--error-sound)
      bad_sound="$2"
      shift 2 ;;
    -q|--quiet)
      quiet=tru
      shift ;;
    -*)
      echo "Unknown option: $1"
      showHelp 418 ;;
    *) shift ;;
  esac; done
}
showHelp () {
  echo "nixos-rebuild-flaek"
  echo "Usage: nixos-rebuild-flaek [args]"

  echo 'assumes ${HOME}/nixos-cfg/#'

 
  echo;echo "Args:                  Desc:"
   # echo "-V|--verbose <  >  . "
   # echo "-T|--test <  >  . "
  echo "-h|--help               show help, exit"
  echo "-p|--profile <name>     specify nixos-rebuild profile name" 
  echo "-d|--dryrun             evaluates config and prints hypothetical paths"
  echo "-D|--debug              ¿¿ 5 ?? "
  echo "-t|--trace              activate nixos-rebuild flag --show-trace"
  echo "-v|--volume <int>       alert volume        (def: ${vol_def})"
  echo "-S|--sound <path>       alert success sound (def: ${sound_def})"
  echo "-E|--error-sound <path> alert error sound   (def: ${bad_sound_def})"
  echo "-q|--quiet              disable alaurm :<"

  alert $1
  exit $1
}
setProfileVar () {
  mkdir -p ${HOME}/.cache/nix
  echo $@ > ${HOME}/.cache/nix/currentProfileName
}
setOpts () {
  [[ ! -s ${HOME}/nixos-cfg/flake.nix ]] && echo flake missing from ${HOME}/nixos-cfg/ && exit 1
  flaek="--impure --flake ${HOME}/nixos-cfg/#"

  version=$(nixos-version | cut -d '.' -f 1,2 | tr -d .)
  [[ $version -ge 2505 ]] && no_reexec="--no-reexec" || no_reexec="--fast"
  
  cp=$(cat ${HOME}/.cache/nix/currentProfileName 2>/dev/null)
  [[ -n "$cp" ]] && p="-p ${cp}"

  opts="${flaek} ${no_reexec} ${p} ${show_trace} ${verbose}"
  export opts
  return
}
run () {
  [[ -n "$debug" ]] && echo "opts: ${opts}"
   
  if [[ -n "$debug" || -n "$dry" ]]; then  nixos-rebuild dry-build ${opts} 1>$tmpout 2>$tmperr
  elif [[ -n "$testbuild" ]]; then    sudo nixos-rebuild test ${opts}
  else                                sudo nixos-rebuild switch ${opts}
  fi

  return $?
}
bell () {
  echo 'bell'
  echo -en "\007"
}
alert () {
  command -v mpv &> /dev/null || mpv_missing=tru
  [[ -n "$mpv_missing" ]] && echo "mpv not installed ${mpv_missing}" && bell && return 418

  [[ -n "$debug" ]] && echo "xit   $1"
  [[ -n "$quiet" ]] && return

  [[ -z "$vol"        ]] && vol=$vol_def
  [[ -z "$sound"      ]] && sound=$sound_def
  [[ -z "$bad_sound"  ]] && bad_sound=$bad_sound_def
  [[ $1 -gt 0         ]] && sound=$bad_sound

  mpv --no-terminal --no-video --keep-open=no --loop-playlist=no  --volume=$vol $sound
}

main $@
