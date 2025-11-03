#!/usr/bin/env bash
debug=0
aliases=("dconf-set-tilix")
main () {
  actions=("read" "write")
  root_conf="/com/gexperts/Tilix/"
  parseArgs "$@"
#  setting=$quake_hide
  confpath="${root_conf}${setting}"
#  val=$(getSetting $setting)
#  print "10." "${method} : ${root_conf}${setting}\n"
  handleSetting
}

# opts () {
  quake_hide="quake-hide-lose-focus"
  quake_mon="quake-specific-monitor"
  quake_mon_ops=(0 1 2)

  quake_x="quake-width-percent"
  quake_y="quake-height-percent"

  current_profile="profiles/${TILIX_ID}/"
  autohide="quake-hide-lose-focus"
  trans="${current_profile}background-transparency-percent" #needs profile
  margin="${current_profile}draw-margin" #needs profile
  openSettings="--preferences"
  showPrefs=""
  name="${current_profile}visible-name"
  setProfile=""
  getProfiles="profiles/list"
  getDefaultProfile="default"

handleSetting () {
  [[ "$method" == "exec" ]] && (tilix "$setting" ; exit $?)
  val=$(getSetting)
#  print "val: $val"
  case "$method" in
    get) echo -e "$val\n";;
    set) setSetting valToSet;;
    toggle) toggleSetting;;
    *) ;;
  esac
}

parseArgs () {
  while [[ $# -gt 0 ]]; do case "$1" in
    -h|--help)
      showhelp 0
      shift;;
    -x|--width-decrease)
      setting=$quake_x
      valToSet=$2
      method="set"
      echo "n/a"; exit 5
      shift 2;;
    -X|--width-increase)
      setting=$quake_x
      valToSet=$2
      method="set"
      echo "n/a"; exit 5
      shift 2;;
    -y|--height-decrease)
      setting=$quake_y
      valToSet=$2
       method="set"
      echo "n/a"; exit 5
      shift 2;;
    -Y|--height-increase)
      setting=$quake_y
      valToSet=$2
       method="set"
      echo "n/a"; exit 5
      shift 2;;
    -m|--mon|--monitor)
      setting=$quake_mon
      valToSet="$2"
       method="set"
      shift 2;;
    -a|--autohide)
      setting=$autohide
      method="toggle"
      shift;;
    -t|--transparency)
      setting=$trans
      [[ -n "$2" ]] && valToSet="$2" && shift || valToSet='0'
      method="set"
#      echo "n/a"; exit 5
      shift;;
    -M|--margin)
      setting=$margin
      valToSet="$2"
       method="set"
      echo "n/a"; exit 5
      shift 2;;
    -s|--settings)
      setting=$openSettings
      method="exec"
      shift;;
    -p|--preferences)
      setting=$showPrefs
       method="exec"
      echo "n/a"; exit 5
      shift;;
    -P|--profile)
      setting=$setProfile
      valToSet="$2"
       method="set"
      echo "n/a"; exit 5
      shift 2;;
    -l|--list-profiles)
      setting=$getProfiles
      method="get"
      shift;;
    -*)
      echo "Unknown option: $1"
      exit 1;;
    *)
      shift;;
  esac done

  [[ -z "$setting" ]] && showhelp 1
}
showhelp () {
  [[ -n "$1" ]] && xCode="$1" || xCode=0
  [[ -z "$setting" ]] && echo -e "No setting found \n"
  echo -e "  tilix-config"
  echo -e "Usage: tilix [opt[value]]\n"
  echo -e "Opts:"
  echo -e " -h | --help                 show help"
  echo -e " -x | --width-decrease [10..100]       quake, increments by 5 if no value"
  echo -e " -X | --width-increase [10..100]       quake, increments by 5 if no value"
  echo -e " -y | --height-decrease [10..100]      quake, increments by 5 if no value"
  echo -e " -Y | --height-increase [10..100]      quake, increments by 5 if no value"
  echo -e " -m | --monitor [0,1,2..]              quake, switches by default"
  echo -e " -A | --autohide                       quake, autohide on focus loss. toggles"
  echo -e " -t | --transparency <percent>         [0]-100"
  echo -e " -M | --margin <col>                   sets margin width placement"
  echo -e " -s | --settings                       open settings"
  echo -e " -p | --preferences-profile                          "
  echo -e " -P | --profile [<profile name>]       set profile"
  echo -e " -l | --list-profiles"

  exit "$xCode"
}
listProfiles () {
  ids=($(dconf read "$root_conf$setting" | tr "[]'," "    "))
  for v in "${ids[@]}"; do
    name=$(dconf read ${root_conf}profiles/$v/visible-name)
    echo -e "$v\t$name";
  done

#  echo ${ids[1]}
}
getSetting () {
#  print "getting $setting"
  [[ "$setting" == "$getProfiles" ]] && (listProfiles ; exit ) #\
#  || dconf read "${root_conf}${setting}"
}
toggleSetting () {
  [[ -z "$setting" || -z "$val" ]] && return 2
  [[ "$val" != "true" && "$val" != "false" ]] && return 1
  [[ "$val" == "true" ]] && valToSet="false" || valToSet="true"
  print "toggling $setting: $valToSet"
  dconf write ${confpath} $valToSet
}
setSetting () {
  [[ -z "$setting" || -z "$val" ]] && return 2
  [[ "$val" == "true" || "$val" == "false" ]] && return 1
  grep -q "height\|width" && (incrementQuakeSize; return)
  print "setting $setting: $valToSet"
  dconf write ${confpath} "$*"
}
incrementQuakeMon () {

}
incrementQuakeSize () {
  [[ -z "$setting" || -z "$val" ]] && return 2
  grep -q "height\|width" || return 1
  #  local quake_xy_range=10..95
  [[ "$valToSet" == '+' && $val -le 95 ]] && valToSet=$(("$val" + 5))
  [[ "$valToSet" == '-' && $val -ge 15 ]] && valToSet=$(("$val" - 5))
  [[ "$valToSet" -lt 10 || "$valToSet" -gt 100 ]] && return 3
  print "increment size $valToSet"
  dconf write ${confpath} $valToSet
}



print () {
  [[ $debug == 0 ]] && return 0
  [[ -z "$*" ]] && echo "print: nil" && return 1
  stamp="$(date +%s)"
  echo -e "[${stamp}] $* \n"
}

main "$@"