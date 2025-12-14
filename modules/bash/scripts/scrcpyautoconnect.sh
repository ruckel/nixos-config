#!/usr/bin/env bash
#scrcpy -e && exit

(($DEBUG)) && echo "debug=${DEBUG}, verbose=${VERBOSE}" #|| echo "!debug"

#(($DEBUG)) && adb disconnect || (adb disconnect &>/dev/null)


cleanExit () {
  echo "clean exiting"
  tailpids=($(pgrep tail));
  pids=$( \
    for pid in ${tailpids[@]}; do \
    ps -p $pid -o pid=,cmd= | tr -s ' '  | grep "f /tmp/std" | cut -d ' ' -f2; \
    done \
  )

  [[ -n "${pids[@]}" ]] && kill -15 ${pids[@]}

  pkill avahi-browse
  pkill -15 scrcpy-wrap
  adb disconnect  #&> /dev/null

  echo "clean, now exiting"
  exit
}

err-notify () {
  echo -e " \e[41merr:\e[49m $1"
  notify-send -a scrcpy -i dialog-error "scrcpy-autoconnect - failed" "$1"
}

trap cleanExit SIGINT

tailing () {
  if (($DEBUG)) && (($VERBOSE)) ; then
    echo tailing
    tail -f /tmp/stdout | grep -iv "truncated\|nix/store/" &
    (tail -f /tmp/stderr 2>/dev/null)  | grep -iv "truncated\|nix/store/" &
  fi
}
runScrcpy () {
  (( ! $(adb -e devices | sed '$d' | sed '1d' | wc -l) )) && echo "no adb devices, no scrcpy ($1)" && return 1
  (($SKIP_SCRCPY)) && echo "skipping scrcpy ($1)" && return 2
  (($DEBUG)) && echo "clearing /tmp/std{out,err}"
  printf "" > /tmp/stdout
  printf "" > /tmp/stderr

  [[ -n "$1" ]] && RUN_ID="$1" || RUN_ID="x"
  (($DEBUG)) && echo -e "\e[42mrun\e[49m scrcpy $RUN_ID "

  #scrcpy -e

  pkill -15 scrcpy-wrap

  scrcpy -e 1>/tmp/stdout 2>/tmp/stderr
  exitCode=$?
  echo "exit code: $exitCode"
  (($exitCode)) && err-notify "$(sed 's/WARN: //g' /tmp/stderr | sed 's/ERROR: //g')"
  exit
}

(($DEBUG)) && echo -e "res line count: $(echo -e "$res" | wc -l)"

scanNetwork () {
  retries=5
  avahi_cmd="avahi-browse --resolve --terminate _adb-tls-connect._tcp"

  res="$($avahi_cmd)"

  while [[ $retries -gt 0 &&  $(echo -e "$res" | wc -l) -le 1 ]]; do
    ((retries--))
    (($DEBUG)) && echo -n "Retrying: '$avahi_cmd' ($retries)"
    sleep .1
    res="$($avahi_cmd)"
    (($VERBOSE)) && echo -e "$res" | wc -l || echo ""
  done

  ips=($(echo -e "$res" | grep address  | sed -E 's/^.*\[(.*)\].*$/\1/' | sort -u | tr '\n' ' '))
  ports=($(echo -e "$res" | grep port | sed -E 's/^.*\[(.*)\].*$/\1/' | sort -u | tr '\n' ' '))
  ipCount="$(echo ${#ips[@]})"

  (($VERBOSE)) && echo -e "avahi-browse res: \n$res  \n--- end res"

  if (($DEBUG)); then
    echo -e "ip count: $ipCount "
    echo -e "\nips: ${ips[*]}"
    echo -e "ports: ${ports[*]} "
  fi
  (($ipCount)) && return 0

  err-notify "avahi-browse returned 0 addresses"
  return 1
}

connectAdb () {
  retries=5
  ip="$1"
  port="$2"

  (($DEBUG)) && echo -en "\nip '$ip', "
  (($DEBUG)) && echo "port '$port'"

 while ! (timeout .1 adb connect "$ip:$port"); do
    [[ $retries -le 0 ]] && echo -e "\nout of port retries: ${ip}:${port} \n\n" && return 1
    ((retries--))
    sleep .25
    (($DEBUG)) && echo -e "retrying: adb connect $ip:$port ($retries)"
  done
  return 0
}

tryAllAdresses () {
  for ip in ${ips[*]}; do
    runScrcpy 0 && exit # || echo " ret0: $?"
    for port in ${ports[*]}; do
      connectAdb "$ip" "$port"
      runScrcpy 1 && exit # || echo " ret1: $?"
    done
    runScrcpy 2 && exit # || echo " ret2: $?"
  done
  runScrcpy 3 && exit # || echo " ret3: $?"
}

scanNetwork && tryAllAdresses
(($DEBUG)) && echo eof
