#!/usr/bin/env bash
scrcpy -e && exit

get="avahi-browse --resolve --terminate _adb-tls-connect._tcp"
res="$($get)"

trap exit 0 SIGINT

retries=5
while [[ $(echo -e "$res" | wc -l) -le 1 && $retries -gt 0 ]]; do
  ((retries--))
  echo "Retrying ($retries) '$get'"
  sleep .1
  res="$($get)"
done

#echo -e "res: '$res'"
echo -e "-- $(echo -e "$res" | grep address | wc -l) --"

ips=($(echo -e "$res" | grep address  | sed -E 's/^.*\[(.*)\].*$/\1/' | sort -u | tr '\n' ' '))
#ips=($(echo -e "address = [69.4.20.0] \n address = [69.0.4.20]" | grep address  | sed -E 's/^.*\[(.*)\].*$/\1/' | sort -u | tr '\n' ' '))
echo -e "ips: ${ips[*]}"

ports=($(echo -e "$res" | grep port | sed -E 's/^.*\[(.*)\].*$/\1/' | sort -u | tr '\n' ' '))
echo -e "ports: ${ports[*]}"

for ip in ${ips[*]}; do
  echo -n "ip '$ip', "
  for port in ${ports[*]}; do
    echo "port '$port'"
    retries=5

    while ! (timeout .1 adb connect "$ip:$port"); do
      [[ $retries -lt 1 ]] && break
      ((retries--))
      sleep .25
      echo -e "retrying ($retries): adb connect $ip:$port"
    done
    #echo -n "post while, "
    scrcpy -e && exit
  done
  #echo -n "post port for, "
  scrcpy -e && exit
done
echo dön
scrcpy -e && exit

