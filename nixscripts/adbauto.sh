#!/bin/sh
adb connect 192.168.1.$1:$2 
echo "adb tcpip 5555" && adb tcpip 5555 
adb disconnect 
echo done && echo 
uip="192.168.1.$1"
echo "uip=$uip" 
