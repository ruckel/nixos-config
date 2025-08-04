#!/usr/bin/env bash

runChatterinoWithDebug(){
DATE=$(date +%Y-%m-%d)
LOGFILENAME=${HOME}/.local/share/chatterino/Logs/${DATE}.log
export QT_MESSAGE_PATTERN="[%{type}] [%{category}] %{message}"  #[debug] blablabla ··· chatterino.sound
export QT_LOGGING_RULES="chatterino.*.debug=true"

chatterino &> $LOGFILENAME
}
runChatterinoWithDebug
