#!/usr/bin/env bash
sleeptime=2

function parseArgs() {
  CMD_TO_RUN=()
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -n|--interval)
        if [[ -n $2 && $2 != -* ]]; then
          sleeptime=$2
          shift 2
        else
          echo "Error: $1 requires a numeric argument"
          exit 1
        fi
        ;;
      -*)
        echo "Unknown option: $1"
        exit 1
        ;;
      *)
        CMD_TO_RUN+=("$@")
        break
        ;;
    esac
  done
  if [[ ${#CMD_TO_RUN[@]} -eq 0 ]]; then
    echo "No command found"
    exit 1
  fi
  CMD_TO_RUN=${CMD_TO_RUN[*]}
}

function listenForExitWhileSleeping() {
  duration=$sleeptime
  interval=0.1
  elapsed=0
  
  while (( $(echo "$elapsed < $duration" | bc -l) )); do
    read -t $interval -n 1 -s key
    if [[ $key == "q" ]]; then exit 0; fi
    elapsed=$(echo "$elapsed + $interval" | bc)
  done
}

function wrap_print() {
  local msg="Every\e[34m $1 \e[39mseconds"
  local time="\e[31m$2\e[39m"
  local cmd="tldr \e[32m$3\e[39m"
  local rawinfo="Every ${1} seconds · ${2}"
  local rawtext="${rawinfo} · $3"
  local text="${msg} · ${time} · q to exit · ${cmd}"
  local width="${columns:-80}"  # fallback if cols unset

  if [ ${#rawtext} -gt $width ]; then
    if [ ${#info} -gt $width ]; then
      text=$(echo "$text" | sed 's/ · / ·\n/g') 
      echo -e "$text" | fold -s -w "$width"
    fi
    #info=$(echo "$info" | sed 's/ · / ·\n/g')
    #text="$info ·\n $cmd"
    echo -e "${msg} · ${time} · q to exit ·\n${cmd}" | fold -s -w "$width"
  else
    echo -e "${text}"
  fi
  echo
}

function listenForTerminalSize() {
  lines=$(tput lines)
  columns=$(tput cols)
  trap 'lines=$(tput lines)'  WINCH
  trap 'columns=$(tput cols)' WINCH
  echo -e "debug: ln: ${lines} · col: ${columns} \n"
}

function run() {
  while true; do
    clear
    wrap_print "${sleeptime}" "$(date +%H:%M)" "${CMD_TO_RUN}"
    #listenForTerminalSize
    tldr ${CMD_TO_RUN}
    listenForExitWhileSleeping
  done
}

function main() {
  parseArgs $@
  run
}

main $@
