#!/usr/bin/env bash
while [[ $# -gt 0 ]]; do case "$1" in
  -w|--window) window="--force-window" && shift ;;
  *) shift ;;
esac; done
[[ -z "${window}" ]] && echo "mpv --input-test --idle"
mpv --input-test --idle ${window}
