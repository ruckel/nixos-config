#!/usr/bin/env bash
file=$1
filename="${file%.*}"
ext="${file##*.}"
filecopy="${filename}~.${ext}"
export TMP=$1
sendAlert() {
  sound=
  mpv --no-terminal --keep-open=no --loop-playlist=no  --volume=130 $1 &
}
echo "$file
$filecopy" >> ~/tmplog


if [ ! -f $file ]; then
  fileExists=false
else
  fileExists=true
fi
if [ ! -f $filecopy ]; then 
  fileCopyExists=false;
else 
  fileCopyExists=true
fi

echo "FILE: $file"
echo "FILEKÅPY: $filecopy"
echo "file yes: ${fileExists}"
echo "backup exist: ${fileCopyExists}"

if [[ ! -f $file ]]; then
  echo file no exist!
  sendAlert "${HOME}/music/miao~~.wav"
  exit 1
fi

if [[ ! -f $filecopy ]]; then
  echo making copy
  cp "${file}" "${filecopy}"
elif [[ ! -f "${filecopy}~" ]]; then
  echo making copycopy   
  cp "${filecopy}" "${filecopy}~"
else
  echo copycopy exis ts
  sendAlert "${HOME}/st/audiofiles/notifications/bonk.mp3"
  exit 1
fi
#alert
exit 0
