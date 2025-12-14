#!/usr/bin/env bash
: <<'END_COMMENT'
/usr/bin/env because of nixos things
END_COMMENT

vol_def=80
sound_def=${HOME}/music/windows3-1startup.mp3  #notjustfart2.wav
bad_sound_def=${HOME}/Music/bwomp.mp
tmpout=/tmp/nixos-build-stdout.txt # $(mktemp -t XXXX)
tmperr=/tmp/nixos-build-stderr.txt  # $(mktemp -t XXXX)3

main () {
  cmd="switch"
  parseArgs "$@"
  setOpts
  run
  xCode=$?
  [[ -n "$debug" ]] && echo stdout: && cat $tmpout && echo stderr && cat $tmperr
  alert $xCode &
  # rm $tmpout $tmperr
  exit $xCode
}
parseArgs() {
  while [[ $# -gt 0 ]]; do case "$1" in
    -h|--help) showHelp 0 ;;
    -p|--profile)
      profile=" -p $2"
      setProfileVar "$2"
      shift 2 ;;
    -b|--build)
      cmd="build"
      shift ;;
    -D|--debug)
      debug=tru
      shift ;;
    -e|--evaluate)
      cmd="eval"
      shift ;;
    -E|--evaluate-all)
      cmd="all"
      shift ;;
    -T|--trace)
      show_trace=" --show-trace"
      shift ;;
    -t|--test)
      cmd="test"
      shift ;;
    -f|--flake)
      flake="$2"
      shift 2 ;;
    -v|--volume)
      vol="$2"
      shift 2 ;;
    -S|--sound)
      sound="$2"
      shift 2 ;;
    -r|--error-sound)
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
  echo "home:$HOME"


  echo;echo "Args:                  Desc:"
   # echo "-V|--verbose <  >  . "
  echo "-e|--evaluate           "
  echo "-t|--test               "
  echo "-h|--help               show help, exit"
  echo "-p|--profile <name>     specify nixos-rebuild profile name"
  #echo "-d|--dryrun             evaluates config and prints hypothetical paths"
  echo "-D|--debug              ¿¿ 5 ?? "
  echo "-T|--trace              activate nixos-rebuild flag --show-trace"
  echo "-v|--volume <int>       alert volume        (def: ${vol_def})"
  echo "-S|--sound <path>       alert success sound (def: ${sound_def})"
  echo "-E|--error-sound <path> alert error sound   (def: ${bad_sound_def})"
  echo "-q|--quiet              disable alaurm :<"

  alert $1 &
  exit $1
}
nixos-version () {
  nixos-rebuild list-generations \
  | grep "True" \
  | tr -s ' ' \
  | cut -d ' ' -f4
}
setProfileVar () {
  if [[ "$1" == "-" ]]; then
    profile=''
    [[ -e  ${HOME}/.cache/nix/currentProfileName ]] \
    && rm "${HOME}/.cache/nix/currentProfileName"
  else
    mkdir -p ${HOME}/.cache/nix
    echo $@ > ${HOME}/.cache/nix/currentProfileName
  fi
}
setOpts () {
#  [[ -z "$flake" ]] && flake=${HOME}/nixos-cfg/#
#  echo $flake
#  [[ ! -s $(echo $flake | sed 's/#/flake.nix/g') ]] && echo flake missing && exit 1
  flaek=" --impure" # --flake $flake"

  version=$(nixos-version | cut -d '.' -f 1,2 | tr -d .)
  [[ -n "$debug" ]] && echo "version: $version"
  [[ $version -ge 2505 ]] && no_reexec=" --no-reexec" || no_reexec=" --fast"

  if [[ "$cmd" == 'switch' && -z "$profile" ]]; then
    last_profile=$(cat ${HOME}/.cache/nix/currentProfileName 2>/dev/null)
    [[ -n "$last_profile" ]] && profile=" -p ${last_profile}"
  fi
  [[ "$cmd" == "switch" || "$cmd" == "test" ]] && \
    if [[ -z "$SUDO_ASKPASS" ]];then USE_SUDO="sudo "; else USE_SUDO="sudo -A "; fi; #echo sudo
  opts="${flaek}${no_reexec}${profile}${show_trace}${verbose}"
  export opts
  return
}
run () {
  #[[ -n "$debug" ]] &&
  sudo -A printf ''
  sudo printf ''
  if  [[ "$cmd" == "eval" ]]; then cmd_to_run="sudo -A nix flake check --arg attrPath .#${HOSTNAME} --impure --no-build --option keep-going true /etc/nixos/#"
  elif [[ "$cmd" == "all" ]]; then cmd_to_run="sudo -A nix flake check --impure --no-build --option keep-going true /etc/nixos/"
  else cmd_to_run="${USE_SUDO}nixos-rebuild ${opts} ${cmd}"
  fi

  echo -e "$cmd_to_run \t\t\t\t $(date +%T)"
  org_pwd=$PWD
  [[ "$cmd" == "build" ]] && (cd /tmp || exit 1)
  [[ "$cmd" == "switch" ]] && sleep 5
  ($cmd_to_run)


  rebuild_exit=$?
  [[ $PWD != "$org_pwd" ]] && (cd "$org_pwd" || exit 1)
  echo -e "\n"
  grep -v "  /nix/store/\|these [0-9]* .* will\|sudo: a " $tmpout
  return $rebuild_exit
}
bell () {
  echo 'bell'
  echo -en "\007"
}
alert () {
  command -v mpv &> /dev/null || mpv_missing=tru
  [[ -n "$mpv_missing" ]] && echo "mpv not installed ${mpv_missing}" && bell && return 1

  [[ -n "$debug" ]] && echo "xit   $1"
  [[ -n "$quiet" ]] && return

  [[ -z "$vol"        ]] && vol=$vol_def
  [[ -z "$sound"      ]] && sound=$sound_def
  [[ -z "$bad_sound"  ]] && bad_sound=$bad_sound_def
  [[ $1 -gt 0         ]] && sound=$bad_sound

  mpv --no-terminal --no-video --keep-open=no --loop-playlist=no  --volume=$vol $sound
}

main "$@"
