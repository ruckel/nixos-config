#!/bin/sh

pidcmd=$(ps -e | grep -w dwm)

dwmPid=$(echo $pidcmd | cut -d " " -f1)
if [[ $dwmPid == '' ]];then
	dwmPid=$(echo $pidcmd | cut -d " " -f2)
fi
if [[ $dwmPid == '' ]];then
	dwmPid=$(echo $pidcmd | cut -d " " -f3)
fi
if [[ $dwmPid == '' ]];then
	dwmPid=$(echo $pidcmd | cut -d " " -f4)
fi
if [[ $dwmPid == '' ]];then
	dwmPid=$(echo $pidcmd | cut -d " " -f5)
fi


echo $dwmPid
kill $dwmPid
