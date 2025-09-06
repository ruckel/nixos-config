parseArgs () {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help|-p|--print)
        SHOWHELP=true
        shift
        ;;
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
