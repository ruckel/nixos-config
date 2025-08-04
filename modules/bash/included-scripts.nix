{ pkgs }:[{
  name = "cowsay-script";
  file = scripts/script.sh;
  deps = with pkgs; [ cowsay ddate ];
} {
  name = "cowsay-scriptus";
  file = scripts/script2.sh;
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
} 
]
/* template
{
  name = "";
  file = scripts/x.sh;
  deps = with pkgs; [  ];
} 
*/
