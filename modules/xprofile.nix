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

  if [[ $HOSTNAME == 'nixburk' ]];then
    autorandr 4screen &
  fi

  echo "" > ~/dwm.txt
  if [ $DESKTOP_SESSION == "none+dwm" ];then
    #echo "waiting $waiti sec" && sleep $waiti
    /home/${vars.user}/dwm/dwmbar.sh &
    /home/${vars.user}/.fswebbg
    #/home/${vars.user}/.fehbg
    syncthing &
  fi
  if [ $DESKTOP_SESSION == "gnome" ];then
    toastify send -a 'xserver' -t 1000 -u normal 'loaded' '.xprofile' 0
  fi

  xfconf-query -c xsettings -p /Net/ThemeName -s "Adwaita-dark"
  gsettings set org.gnome.desktop.interface color-scheme prefer-dark
  gsettings set org.gnome.desktop.interface icon-theme Adwaita-dark
  gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark
  echo -e \"[Settings]\ngtk-application-prefer-dark-theme = 1\ngtk-theme-name = Adwaita-dark\ngtk-icon-theme-name = Adwaita-dark\n" > /home/${vars.user}/.config/gtk-3.0/settings.ini
  QT_STYLE_OVERRIDE=Adwaita-Dark
  ln -rs  ~/.config/gtk-3.0/settings.ini ~/.gtkrc-2.0
  ln -rs  ~/.config/gtk-3.0/settings.ini ~/.config/gtk-3.0/settings.ini
  setxkbmap korvus
  /home/korv/scripts/pipewire.sh
fi
'';}
