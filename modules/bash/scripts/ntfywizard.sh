#!/usr/bin/env bash
: <<'END_COMMENT'
  /usr/bin/env because of nixos things

  NTFY_MARKDOWN=false
  NTFY_DELAY=10s              # 1m | 1h | 1 day | 10am
  NTFY_CLICK="korv.lol"       # URL to open when clicked
  NTFY_ATTACH=                # URL to send as an external attachment
  NTFY_FILENAME=              # name for attachment
  NTFY_FILE=                  # file to upload as attachment
  NTFY_WAIT_PID=0             # pub after PID exits
  NTFY_WAIT_CMD=              # pub after cmd finnish
END_COMMENT

main () {
  parseArgs $@
  #echo t:$NTFY_TOPIC, m:$NTFY_MESSAGE
  setVars $@
  send
  #echo t:$NTFY_TOPIC, m:$NTFY_MESSAGE
}
ntfyVar () {
  sed -i "/i${1}/d"  /tmp/ntfyVars.sh 2>/dev/null
  echo "export ${1}=\"${2}\"" >> /tmp/ntfyVars.sh
}
setVars () {
  [[ -s /tmp/ntfyVars.sh ]] && . /tmp/ntfyVars.sh #&& echo såsed
  #msg="message"
  tags=poop,hotdog
  priority=3
  icon="https://cdn.betterttv.net/emote/6335f175ee60425d31b6c9a3/3x"
  topic=korvintihi
  title="ntfywizz"
  topic=korvintihi
  
  [[ -n "$msg" ]] && msg="$1" export NTFY_MESSAGE=${msg} && ntfyVar message "${msg}"
  #echo "${key}: '${val}'"
  deps=(NTFY_TOPIC NTFY_TITLE NTFY_MESSAGE) #)
  for var in "${deps[@]}"; do if [[ -z "${!var}" ]];then
    echo -n "${var}: "
    read input
    [[ -z "$input" ]] && exit 1
    ntfyVar ${var} $input
    export ${var}=${input}
  fi; done

  ntfyVars=(NTFY_FILENAME NTFY_FILE NTFY_TAGS NTFY_ICON NTFY_PRIORITY)
  for var in "${ntfyVars[@]}"; do if [[ -z "${!var}" && -z "$skip" ]];then
    echo -n "set $var? [n|[S]kip|text]: "
    read input
    if [[ "$input" == "skip" || "$input" == "S" || "$input" == 's' ]];then
      skip=tru
    elif [[ "$input" != "n" ]]; then 
      ntfyVar ${var} $input
      export ${var}=${input}      
    fi
    
  fi; done


  [[ -n "$verbose" ]] && for var in "${deps[@]}"; do echo $var: ${!var};done
  [[ -n "$verbose" ]] && for var in "${ntfyVars[@]}"; do echo $var: ${!var};done

  #tmp=$(mktemp -t var.XXX)
  #echo export FOO=BAR > $tmp
  #. $tmp
  #echo "$tmp, \$FOO=$FOO"
  #rm $tmp
  

}
send () {
  
  [[ -n "$verbose" ]] && echo "ntfy top:$NTFY_TOPIC, tit:$NTFY_TITLE, msg:$NTFY_MESSAGE"
  [[ -n $unsend ]] && export NTFY_TOPIC=$(mktemp -u "random-XXXXXXXXXXXXXXXXXXX")
  tmp_out=$(mktemp -t ntfyw-XXXX.json)
  NTFY_TOPIC=$NTFY_TOPIC ntfy pub > $tmp_out ; ntfyX=$?
  [[ -n "$verbose" ]] && jq . $tmp_out
  rm $tmp_out
  return $ntfyX

}
parseArgs () {
  while [[ $# -gt 0 ]]; do case "$1" in
    -h|--help)
      SHOWHELP=tru
      verbose=tru
      shift ;;
    -v|--verbose)
      verbose=tru
      shift ;; 
    -c|--config)
      [[ ! -r $2 ]] && echo cant read conf && exit 1
      source $2 && cat $2
      shift 2
      ;;
    -s|--skip)
      skip=tru
      shift
      ;;
    -d|--defconfig)
      #[[ ! -r $2 ]] && echo cant read conf && exit 1
      source /etc/ntfywizz.conf
      shift
      ;;
    -u|--unsend)
      #verbose=tru
      unsend=tru
      shift ;;
    -*)
      echo "Unknown option: $1"
      exit 1
      ;;
    *)
      export msg+="$1 "
      shift
      ;;
  esac; done
}

main $@
