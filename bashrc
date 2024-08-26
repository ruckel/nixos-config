aliasfile=./bashaliases
if [ -f $aliasfile ]; then . $aliasfile
else echo noaliases; fi

#psFile=~/.config/tilix/config/setPrompt
#if [ -f $psFile ]; then . $psFile
#else echo nops; fi
VISUAL=vim
EDITOR=$VISUAL

#tilixheightPercent 20
