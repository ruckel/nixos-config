#!/usr/bin/env bash

output_dir="${HOME}/Music/rip"
ext=wav

main () {
  dependencyCheck xdotool xprop echo grep sed sleep pw-cat

  win_id=$(xdotool search --onlyvisible --class spotify | head -n1)
  last_win_title=""
  mkdir -p "${output_dir}"
  loop
}

dependencyCheck () {
  deps=(bash)
  missing=()
 
  [[ -n "$1" ]] && deps=($@)
  #echo "deps: ${deps[@]}" 
  
  for dep in "${deps[@]}"; do
    #echo "dep: $dep"
    if ! command -v "$dep" >/dev/null 2>&1; then
      missing+=("$dep")
    fi  
  done
  
  if [ ${#missing[@]} -ne 0 ]; then
    echo "Missing dependencies: ${missing[*]}"
    exit 1
  fi  
}
sanitize_filename () {
  echo "$1" | sed 's/[^[:alnum:]_-]/_/g'
}
stop_record_job () {
  [[ "$1" != "" ]] && \
  echo "stopping pw-cat" && \
  pkill -f "pw-cat -r --target spotify" 2>/dev/null
}
loop () {
  while true; do
    win_title=$(xprop -id "$win_id" | grep -E '^WM_NAME' | sed -E 's/.* = "(.*)"/\1/')
  
    # If title changed and isn't empty, (re-)start recording
    if [[ "$win_title" != "$last_win_title" && -n "$win_title" ]]; then
      stop_record_job "${last_win_title}"
      safe_filename=$(sanitize_filename "$win_title")
  
      [[ $win_title != "Spotify Premium" ]] && \
      echo "Starting new recording: ${safe_filename}.${ext}" && \
        pw-cat -r --target spotify --format f64 "${output_dir}/${safe_filename}.${ext}" &
        last_win_title="$win_title"
    fi
  
      sleep .25  # check every Ns
  done
}

main
