#!/bin/sh

run() {
idleTime=$(xprintidle)
limit=1
limitMs=$(($limit * 1000))

echo limitMs: $limitMs
echo idle: $idleTime
echo "if [[ $idleTime -gt $limitMs ]];then"

if [[ $idleTime -gt $limitMs ]];then
  echo goognite
  #systemctl suspend-then-hibernate
fi
echo no goggi
}

loop() {
#sleep 600
while true; do
  run
  sleep 600
done
}

loop
