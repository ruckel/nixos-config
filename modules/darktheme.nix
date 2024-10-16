{ lib, config, ... }:
let
  cfg = darktheme.config;
in
{
  options.darktheme.enable = true;

  config = lib.mkIf cfg.enable {
    environment.etc."xprofile2".text = ''
    xfconf-query -c xsettings -p /Net/ThemeName -s           "Adwaita-dark"
    gsettings set org.gnome.desktop.interface icon-theme      Adwaita-dark
    gsettings set org.gnome.desktop.interface gtk-theme       Adwaita-dark
    gsettings set org.gnome.desktop.interface color-scheme    prefer-dark
    gsettings set org.freedesktop.appearance color-scheme     prefer-dark

    echo "[Settings]"                                        >  ~/.config/gtk-3.0/settings.ini
    echo "gtk-application-prefer-dark-theme = 1"            >>  ~/.config/gtk-3.0/settings.ini
    echo "gtk-theme-name =                  Adwaita-dark"   >>  ~/.config/gtk-3.0/settings.ini
    echo "gtk-icon-theme-name =             Adwaita-dark"   >>  ~/.config/gtk-3.0/settings.ini

    ln -rs  ~/.config/gtk-3.0/settings.ini                      ~/.gtkrc-2.0
    ln -rs  ~/.config/gtk-3.0/settings.ini                      ~/.config/gtk-3.0/settings.ini

    export QT_STYLE_OVERRIDE=Adwaita-dark
    export GTK_THEME=Adwaita-dark
    '';
  };
}