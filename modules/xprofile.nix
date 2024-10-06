let vars = import ../vars.nix;
in
{ environment.etc."xprofile".text = ''
#!/bin/sh
waiti=20
if [ -z $_XPROFILE_SOURCED ]; then
  export _XPROFILE_SOURCED=1
  export GTK_THEME=Adwaita-dark
  xrandr

  dunst &
  x11vnc -forever -noxdamage  -passwdfile ~/.vnc/passwd &


  echo "" > ~/dwm.txt
  if [ $DESKTOP_SESSION == "none+dwm" ];then
    #echo "waiting $waiti sec" && sleep $waiti
    /etc/nixos/dwm/dwmbar.sh &
    /home/${vars.user}/.fswebbg
    #/home/${vars.user}/.fehbg
    syncthing &
  fi
  if [ $DESKTOP_SESSION == "gnome" ];then
    toastify send -a 'xserver' -t 1000 -u normal 'loaded' '.xprofile' 0
  fi


  setxkbmap korvus
  /home/korv/scripts/pipewire.sh
fi
'';}
