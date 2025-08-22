{ pkgs }:[{
  name = "cowsay-script";
  file = scripts/cowsay-script.sh;
  deps = with pkgs; [ cowsay ddate ];
} {
  name = "cowsay-scriptus";
  file = scripts/cowsay-scriptus.sh;
  deps = with pkgs; [ cowsay ];
} { 
  name = "exec-with-watch";
  file = scripts/exec-with-watch.sh;
  deps = with pkgs; [ inotify-tools ];
} { 
  name = "alert";
  file = scripts/alert.sh;
  deps = with pkgs; [ toastify mpv ];
} { 
  name = "files";
  file = scripts/thunardark.sh;
  deps = with pkgs; [ xfce.thunar ];
} { 
  name = "backupfile";
  file = scripts/backupfile.sh;
  deps = with pkgs; [ mpv ];
} { 
  name = "watcher";
  file = scripts/watcher.sh;
  deps = with pkgs; [];
} {
  name = "i3lock";
  file = scripts/i3lock.sh;
  deps = with pkgs; [ i3lock ];
} {
  name = "nixswitch";
  file = scripts/nixswitch.sh;
  deps = with pkgs; [ bash sudo coreutils libnotify busybox dunst ];
} {
  name = "ntfywizz";
  file = scripts/ntfywizard.sh;
  deps = with pkgs; [ coreutils ntfy-sh jq ];
} {
  name = "ntfyvar";
  file = scripts/ntfy-var-setter.sh;
  deps = with pkgs; [ coreutils ntfy-sh sed ];
} 
]
/* template
{
  name = "";
  file = scripts/x.sh;
  deps = with pkgs; [  ];
} 
*/
