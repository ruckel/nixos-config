#!/bin/sh

toKill='dontkillanything please'
if [[ $1 != '' ]];then toKill=$1;fi

ps -ef | grep $toKill | grep -v grep | awk '{print $2}' | xargs -r kill -15
