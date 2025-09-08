#!/usr/bin/env bash
: <<'END_COMMENT'
/usr/bin/env because of nixos things

END_COMMENT

tmp=/tmp/ntfyvars.sh
main() {
  parseArgs $@
  [[ -z "$1" ]] && echo missing key && exit 1
  delVals=('x' 'X' '-' '-d' '')
  #tr_tmp=$(mktemp -t tr.XXXX)
  key="NTFY_$(echo $1 | tr '[:lower:]' '[:upper:]' | sed 's/NTFY_//g')"
  shift
  val="$@"
  for v in "${delVals[@]}"; do [[ $val == $v ]] && del=tru; done
  #[[ ! -d /tmp/nfty ]] && mkdir -p /tmp/ntfy
  #tmp=$(mktemp -t ntfyvars)
  #newtmp=$(grep -v "${key}\|^$" $tmp)
  #echo key:$key
  sed -i "/${key}/d" $tmp 2>/dev/null
  #echo $newtmp  2>/dev/null > $tmp
  [[ -z "$del" ]] && echo "export ${key}=\"${val}\"" >> $tmp
  new=$(echo \$key)
  #echo "${key}: '${val}'"
  #bat -pp $tmp
}

parseArgs() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help|-p|--print)
        SHOWHELP=true
        shift
        ;;
      -g|--get)
        [[ -e $tmp ]] && bat -p $tmp
        exit
        ;; 
      -c|--clear)
        echo clearing vars
        [[ -e $tmp ]] && rm $tmp
        exit ;;
      -*)
        echo "Unknown option: $1"
        exit 1
        ;;
      *)
        shift
        ;;
    esac
  done
}

run() {
  echo "another func, $@" ; echo_status=$?
  rm non/ExistingFile &> /dev/null ; rm_status=$?
  [[ $rm_status == "1" ]] && return || rm -r non && return 1
}

main $@
